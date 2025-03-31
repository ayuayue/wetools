import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_page.dart';
import 'pages/system_page.dart';
import 'utils/clipboard_util.dart';
import 'utils/logger_util.dart';
import 'package:provider/provider.dart';
import 'utils/theme_util.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'services/update_service.dart';
import 'dart:async';
import 'widgets/update_progress_dialog.dart';
import 'utils/settings_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tray_manager/tray_manager.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志系统
  await LoggerUtil.init();

  // 设置异常处理
  FlutterError.onError = (FlutterErrorDetails details) {
    // 忽略键盘事件相关的错误
    if (details.exception.toString().contains('KeyDownEvent')) {
      return;
    }
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerUtil.error('未捕获的异步异常', error, stack);
    return true;
  };

  // 初始化窗口管理器
  await windowManager.ensureInitialized();

  // 配置窗口
  await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(1280, 800),
        minimumSize: Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        windowButtonVisibility: true,
      ), () async {
    // 只禁用菜单栏的最大最小化，保留窗口标题栏按钮
    await windowManager.setPreventClose(true);
    await windowManager.show();
    await windowManager.focus();
  });

  // 初始化自启动功能
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    launchAtStartup.setup(
      appName: 'WeTools',
      appPath: Platform.resolvedExecutable,
    );
  }

  // 运行应用
  runApp(const MyApp());
  LoggerUtil.info('应用启动');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeUtil(),
      child: Consumer<ThemeUtil>(
        builder: (context, themeUtil, _) {
          return MaterialApp(
            scaffoldMessengerKey: ClipboardUtil.rootScaffoldMessengerKey,
            title: 'WeTools',
            themeMode: themeUtil.themeMode,
            theme: ThemeData(
              // 亮色主题
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'SourceHanSansSC',
              textTheme: const TextTheme(
                headlineMedium: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                titleLarge: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF444444),
                ),
                bodyLarge: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
                bodyMedium: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            darkTheme: ThemeData(
              // 暗色主题
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'SourceHanSansSC',
            ),
            home: const AppFrame(),
          );
        },
      ),
    );
  }
}

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with WindowListener, TrayListener {
  Timer? _updateCheckTimer;
  String _version = '';
  bool _isQuitting = false;

  @override
  void initState() {
    super.initState();
    _initUpdateCheck();
    _loadVersion();
    SettingsUtil.addListener(_initUpdateCheck);
    // 添加窗口监听器
    windowManager.addListener(this);

    // 添加托盘监听器
    trayManager.addListener(this);

    // 初始化系统托盘
    _initSystemTray();
  }

  // 初始化系统托盘
  Future<void> _initSystemTray() async {
    // 设置托盘图标
    String iconPath = Platform.isWindows
        ? 'assets/icon/app_icon.ico'
        : Platform.isMacOS
            ? 'assets/icon/app_icon.png'
            : 'assets/icon/app_icon.ico';

    await trayManager.setIcon(iconPath);
    await trayManager.setToolTip('WeTools');

    // 设置托盘菜单
    await _setTrayMenu();
  }

  // 设置托盘菜单
  Future<void> _setTrayMenu() async {
    final Menu menu = Menu(
      items: [
        MenuItem(
          label: '显示',
          onClick: (_) async {
            await windowManager.show();
            await windowManager.focus();
          },
        ),
        MenuItem.separator(),
        MenuItem(
          label: '退出',
          onClick: (_) async {
            _isQuitting = true;
            await windowManager.close();
          },
        ),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  // 窗口关闭请求处理
  @override
  void onWindowClose() async {
    if (_isQuitting) {
      // 如果是真正要退出，就允许关闭
      await windowManager.destroy();
    } else {
      // 否则隐藏窗口到托盘
      await windowManager.hide();

      // 显示托盘通知
      if (Platform.isWindows) {
        // await trayManager.showNotification(
        //   title: 'WeTools',
        //   message: 'WeTools 正在后台运行',
        // );
      }
    }
  }

  // 托盘图标点击事件
  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
    await windowManager.focus();
  }

  // 托盘图标右键点击事件
  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void dispose() {
    _updateCheckTimer?.cancel();
    SettingsUtil.removeListener(_initUpdateCheck);
    windowManager.removeListener(this); // 添加移除窗口监听器
    trayManager.removeListener(this); // 添加移除托盘监听器
    super.dispose();
  }

  Future<void> _initUpdateCheck() async {
    _updateCheckTimer?.cancel();

    final autoCheck = await SettingsUtil.getAutoUpdateCheck();
    if (!autoCheck) return;

    final interval = await SettingsUtil.getUpdateCheckInterval();
    // 启动时检查更新
    _checkUpdateSilently();
    // 设置定时检查
    _updateCheckTimer = Timer.periodic(
      Duration(hours: interval),
      (_) => _checkUpdateSilently(),
    );
  }

  Future<void> _checkUpdateSilently() async {
    try {
      final result = await UpdateService.checkUpdate();
      if (!mounted) return;

      if (result.hasUpdate) {
        if (!mounted) return;
        final bool? shouldUpdate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('发现新版本'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('最新版本: ${result.latestVersion}'),
                const SizedBox(height: 8),
                if (result.releaseNotes != null) ...[
                  const Text('更新内容:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(result.releaseNotes!),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('稍后再说'),
              ),
              if (result.downloadUrl != null)
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('立即更新'),
                ),
            ],
          ),
        );

        if (shouldUpdate == true && mounted) {
          final bool? confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('确认更新'),
              content: const Text('更新将会覆盖当前版本并重启应用，是否继续？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('确认'),
                ),
              ],
            ),
          );

          if (confirm == true && mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UpdateProgressDialog(
                downloadUrl: result.downloadUrl!,
              ),
            );
          }
        }
      }
    } catch (e) {
      // 静默检查更新失败时不显示错误
      debugPrint('静默检查更新失败: $e');
    }
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _openGitHub() async {
    const url = 'https://github.com/ayuayue/wetools';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 40,
              color: Colors.grey.shade500, // 设置标题栏颜色
              child: Row(
                children: [
                  // 拖动区域，用于移动窗口
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent, // 确保即使透明区域也能接收拖动事件
                      onPanStart: (details) {
                        windowManager.startDragging();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'WeTools',
                          style: TextStyle(
                            color: Colors.black, // 标题文字颜色
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 窗口控制按钮
                  _buildWindowButton(
                    Icons.remove,
                    () => windowManager.minimize(),
                  ),
                  _buildWindowButton(
                    Icons.crop_square,
                    () async {
                      if (await windowManager.isMaximized()) {
                        windowManager.unmaximize();
                      } else {
                        windowManager.maximize();
                      }
                    },
                  ),
                  _buildWindowButton(
                    Icons.close,
                    () => windowManager.close(),
                    hoverColor: Colors.blue,
                  ),
                ],
              )),
          if (Platform.isWindows) _buildMenuBar(context),
          const Expanded(
              child: MyHomePage(
            title: '开发者工具箱',
            scrollToTop: true,
          )),
        ],
      ),
    );
  }

  Widget _buildWindowButton(IconData icon, VoidCallback onPressed,
      {Color? hoverColor}) {
    return InkWell(
      onTap: onPressed,
      hoverColor: hoverColor ?? Colors.black12,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      height: 30,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          const SizedBox(width: 8),
          _buildMenuItem(
            context,
            '首选项',
            [
              PopupMenuItem(
                child: const Text('设置'),
                onTap: () => _showSettingsDialog(context),
              ),
              PopupMenuItem(
                child: const Text('系统信息'),
                onTap: () => _showSystemInfoDialog(context),
              ),
              PopupMenuItem(
                child: const Text('重启'),
                onTap: () async {
                  // 延迟执行以避免菜单关闭动画问题
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (mounted) {
                    _restartApp();
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('退出'),
                onTap: () => windowManager.close(),
              ),
            ],
          ),
          _buildMenuItem(
            context,
            '帮助',
            [
              PopupMenuItem(
                child: const Text('关于'),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const Spacer(),
          // IconButton(
          //   icon: const Icon(Icons.remove, size: 18),
          //   onPressed: () => windowManager.minimize(),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.crop_square, size: 18),
          //   onPressed: () async {
          //     if (await windowManager.isMaximized()) {
          //       windowManager.restore();
          //     } else {
          //       windowManager.maximize();
          //     }
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.close, size: 18),
          //   onPressed: () => windowManager.close(),
          // ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    List<PopupMenuEntry> items,
  ) {
    return PopupMenuButton(
      tooltip: '',
      itemBuilder: (_) => items,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(title),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
          child: const SettingsPage(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
            child: const AboutPage(),
          ),
        ),
      ),
    );
  }

  void _showSystemInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
          child: const SystemPage(),
        ),
      ),
    );
  }

  Future<void> _restartApp() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认重启'),
        content: const Text('确定要重启应用程序吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('重启'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final executablePath = Platform.resolvedExecutable;
      await Process.start(executablePath, []);
      exit(0);
    }
  }
}

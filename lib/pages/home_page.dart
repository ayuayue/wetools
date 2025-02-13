import 'package:flutter/material.dart';
import 'package:wetools/pages/base64_page.dart';
import 'package:wetools/pages/hash_page.dart';
import 'package:wetools/pages/json_page.dart';
import 'package:wetools/pages/jwt_page.dart';
import 'package:wetools/pages/text_page.dart';
import 'package:wetools/pages/url_page.dart';
import 'time_page.dart';
import 'translate_page.dart';
import 'http_page.dart';
import 'tcp_page.dart';
import 'ip_page.dart';
import 'email_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = const [
    // 文本处理类
    NavigationRailDestination(
      icon: Icon(Icons.text_fields),
      label: Text('文本'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.translate),
      label: Text('翻译'),
    ),
    // 编码解码类
    NavigationRailDestination(
      icon: Icon(Icons.link),
      label: Text('URL'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.code),
      label: Text('Base64'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.data_object),
      label: Text('JSON'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.key),
      label: Text('JWT'),
    ),
    // 安全工具类
    NavigationRailDestination(
      icon: Icon(Icons.security),
      label: Text('Hash'),
    ),
    // 网络工具类
    NavigationRailDestination(
      icon: Icon(Icons.http),
      label: Text('HTTP'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.lan),
      label: Text('TCP'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.public),
      label: Text('IP'),
    ),
    // 其他工具类
    NavigationRailDestination(
      icon: Icon(Icons.timer),
      label: Text('时间'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.email),
      label: Text('邮件'),
    ),
  ];

  final List<({Widget page, String label})> _pages = const [
    // 文本处理类
    (page: TextPage(), label: '文本'),
    (page: TranslatePage(), label: '翻译'),
    // 编码解码类
    (page: UrlPage(), label: 'URL'),
    (page: Base64Page(), label: 'Base64'),
    (page: JsonPage(), label: 'JSON'),
    (page: JwtPage(), label: 'JWT'),
    // 安全工具类
    (page: HashPage(), label: 'Hash'),
    // 网络工具类
    (page: HttpPage(), label: 'HTTP'),
    (page: TcpPage(), label: 'TCP'),
    (page: IpPage(), label: 'IP'),
    // 其他工具类
    (page: TimePage(), label: '时间'),
    (page: EmailPage(), label: '邮件'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations,
                  minWidth: 85, // 设置最小宽度，避免文字换行
                  useIndicator: true, // 使用指示器
                  groupAlignment: -1, // 将项目对齐到顶部
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex].page,
          ),
        ],
      ),
    );
  }
}

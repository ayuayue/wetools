import 'package:flutter/material.dart';

/// 面包屑导航项
class BreadcrumbItem {
  /// 显示的标题
  final String title;

  /// 点击时的回调函数
  final VoidCallback onTap;

  /// 是否为最后一项（通常最后一项不可点击）
  final bool isLast;

  BreadcrumbItem({
    required this.title,
    required this.onTap,
    this.isLast = false,
  });
}

/// 面包屑导航组件
class BreadcrumbNavigation extends StatelessWidget {
  /// 面包屑项列表
  final List<BreadcrumbItem> items;

  /// 文本颜色
  final Color? textColor;

  /// 分隔符颜色
  final Color? separatorColor;

  /// 字体大小
  final double fontSize;

  const BreadcrumbNavigation({
    Key? key,
    required this.items,
    this.textColor,
    this.separatorColor,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualTextColor = textColor ?? theme.colorScheme.primary;
    final actualSeparatorColor =
        separatorColor ?? theme.colorScheme.onSurface.withOpacity(0.5);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length * 2 - 1, (index) {
          // 分隔符
          if (index.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.chevron_right,
                size: fontSize + 2,
                color: actualSeparatorColor,
              ),
            );
          }

          // 面包屑项
          final itemIndex = index ~/ 2;
          final item = items[itemIndex];

          return InkWell(
            onTap: item.isLast ? null : item.onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: fontSize,
                  color: item.isLast
                      ? theme.colorScheme.onSurface
                      : actualTextColor,
                  fontWeight: item.isLast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

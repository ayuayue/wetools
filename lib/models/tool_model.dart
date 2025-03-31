import 'package:flutter/material.dart';

/// 工具模型类
class ToolModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Widget page;
  final String groupId;
  final List<String> tags;

  const ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.page,
    required this.groupId,
    this.tags = const [],
  });
}

/// 工具分组模型
class ToolGroup {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const ToolGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

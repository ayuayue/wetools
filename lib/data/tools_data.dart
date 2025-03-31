import 'package:flutter/material.dart';
import '../models/tool_model.dart';
import '../pages/base64_page.dart';
import '../pages/hash_page.dart';
import '../pages/json_page.dart';
import '../pages/jwt_page.dart';
import '../pages/text_page.dart';
import '../pages/url_page.dart';
import '../pages/time_page.dart';
import '../pages/translate_page.dart';
import '../pages/http_page.dart';
import '../pages/tcp_page.dart';
import '../pages/ip_page.dart';
import '../pages/email_page.dart';
import '../pages/clipboard_page.dart';
import '../pages/hosts_page.dart';
import '../pages/ftp_page.dart';
import '../pages/process_page.dart';

/// 工具数据提供类
class ToolsData {
  // 工具分组列表
  static final List<ToolGroup> groups = [
    const ToolGroup(
      id: 'text',
      name: '文本工具',
      description: '文本处理工具',
      icon: Icons.text_fields,
      color: Colors.teal,
    ),
    const ToolGroup(
      id: 'encode',
      name: '编码转换',
      description: '各类编码转换工具',
      icon: Icons.transform,
      color: Colors.orange,
    ),
    const ToolGroup(
      id: 'network',
      name: '网络工具',
      description: '网络相关工具',
      icon: Icons.public,
      color: Colors.blue,
    ),
    const ToolGroup(
      id: 'time',
      name: '时间工具',
      description: '时间相关工具',
      icon: Icons.access_time,
      color: Colors.purple,
    ),
    const ToolGroup(
      id: 'system',
      name: '系统工具',
      description: '系统相关工具',
      icon: Icons.computer,
      color: Colors.red,
    ),
    const ToolGroup(
      id: 'crypto',
      name: '加密工具',
      description: '加密解密工具',
      icon: Icons.security,
      color: Colors.indigo,
    ),
  ];

  // 工具列表
  static final List<ToolModel> tools = [
    // 文本工具
    ToolModel(
      id: 'text',
      name: '文本处理',
      description: '文本编辑和处理工具',
      icon: Icons.text_fields,
      page: const TextPage(),
      groupId: 'text',
      tags: ['文本', '编辑', '处理'],
    ),
    ToolModel(
      id: 'translate',
      name: '翻译工具',
      description: '多语言翻译工具',
      icon: Icons.translate,
      page: const TranslatePage(),
      groupId: 'text',
      tags: ['翻译', '语言', '多语言'],
    ),
    ToolModel(
      id: 'clipboard',
      name: '剪贴板管理',
      description: '管理剪贴板历史记录',
      icon: Icons.content_paste,
      page: const ClipboardPage(),
      groupId: 'text',
      tags: ['剪贴板', '复制', '粘贴'],
    ),

    // 编码转换
    ToolModel(
      id: 'url',
      name: 'URL编解码',
      description: 'URL编码和解码工具',
      icon: Icons.link,
      page: const UrlPage(),
      groupId: 'encode',
      tags: ['URL', '编码', '解码'],
    ),
    ToolModel(
      id: 'base64',
      name: 'Base64转换',
      description: 'Base64编码和解码工具',
      icon: Icons.code,
      page: const Base64Page(),
      groupId: 'encode',
      tags: ['Base64', '编码', '解码'],
    ),
    ToolModel(
      id: 'json',
      name: 'JSON格式化',
      description: 'JSON格式化和校验工具',
      icon: Icons.data_object,
      page: const JsonPage(),
      groupId: 'encode',
      tags: ['JSON', '格式化', '校验'],
    ),
    ToolModel(
      id: 'jwt',
      name: 'JWT解析',
      description: 'JWT令牌解析工具',
      icon: Icons.key,
      page: const JwtPage(),
      groupId: 'encode',
      tags: ['JWT', '令牌', '解析'],
    ),

    // 网络工具
    ToolModel(
      id: 'http',
      name: 'HTTP请求',
      description: 'HTTP请求测试工具',
      icon: Icons.http,
      page: const HttpPage(),
      groupId: 'network',
      tags: ['HTTP', '请求', 'API'],
    ),
    ToolModel(
      id: 'tcp',
      name: 'TCP测试',
      description: 'TCP连接测试工具',
      icon: Icons.lan,
      page: const TcpPage(),
      groupId: 'network',
      tags: ['TCP', '连接', '网络'],
    ),
    ToolModel(
      id: 'ip',
      name: 'IP工具',
      description: 'IP地址查询和分析工具',
      icon: Icons.public,
      page: const IpPage(),
      groupId: 'network',
      tags: ['IP', '地址', '查询'],
    ),
    ToolModel(
      id: 'email',
      name: '邮件工具',
      description: '邮件发送测试工具',
      icon: Icons.email,
      page: const EmailPage(),
      groupId: 'network',
      tags: ['邮件', '发送', 'SMTP'],
    ),
    ToolModel(
      id: 'ftp',
      name: '文件共享',
      description: '局域网文件共享工具',
      icon: Icons.folder_shared,
      page: const FtpPage(),
      groupId: 'network',
      tags: ['文件', '共享', 'FTP'],
    ),

    // 时间工具
    ToolModel(
      id: 'time',
      name: '时间转换',
      description: '时间戳转换工具',
      icon: Icons.timer,
      page: const TimePage(),
      groupId: 'time',
      tags: ['时间', '时间戳', '转换'],
    ),

    // 系统工具
    ToolModel(
      id: 'process',
      name: '进程管理',
      description: '系统进程查看和管理',
      icon: Icons.memory,
      page: const ProcessPage(),
      groupId: 'system',
      tags: ['进程', '系统', '管理'],
    ),
    ToolModel(
      id: 'hosts',
      name: 'Hosts管理',
      description: '系统Hosts文件管理',
      icon: Icons.dns,
      page: const HostsPage(),
      groupId: 'system',
      tags: ['Hosts', 'DNS', '系统'],
    ),

    // 加密工具
    ToolModel(
      id: 'hash',
      name: 'Hash计算',
      description: '文本和文件Hash计算',
      icon: Icons.security,
      page: const HashPage(),
      groupId: 'crypto',
      tags: ['Hash', 'MD5', 'SHA'],
    ),
  ];

  // 根据ID获取工具
  static ToolModel? getToolById(String id) {
    try {
      return tools.firstWhere((tool) => tool.id == id);
    } catch (e) {
      return null;
    }
  }

  // 根据ID获取分组
  static ToolGroup? getGroupById(String id) {
    try {
      return groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  // 获取分组下的所有工具
  static List<ToolModel> getToolsByGroup(String groupId) {
    return tools.where((tool) => tool.groupId == groupId).toList();
  }

  // 搜索工具
  static List<ToolModel> searchTools(String keyword) {
    if (keyword.isEmpty) return [];

    keyword = keyword.toLowerCase();
    return tools.where((tool) {
      return tool.name.toLowerCase().contains(keyword) ||
          tool.description.toLowerCase().contains(keyword) ||
          tool.tags.any((tag) => tag.toLowerCase().contains(keyword));
    }).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '开发者工具箱',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('版本: 1.0.0'),
                    const SizedBox(height: 16),
                    const Text(
                      '功能介绍:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('''
• JWT 编解码工具
• URL 编解码工具
• Base64 编解码工具
• JSON 格式化工具
• Hash 计算工具
• 文本处理工具'''),
                    const SizedBox(height: 16),
                    const Text(
                      '开发者:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('作者: caoayu'),
                    const Text('邮箱: 1401262639@qq.com'),
                    const SizedBox(height: 16),
                    const Text(
                      '项目信息:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _launchUrl('https://github.com/ayuayue/wetools'),
                      child: const Text(
                        'GitHub 仓库',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '说明:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '这是一个为开发者设计的工具箱，提供了常用的编码解码、格式化、加密等功能。'
                      '使用 Flutter 开发，支持跨平台运行。\n\n'
                      '本项目开源，欢迎贡献代码或提出建议。',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
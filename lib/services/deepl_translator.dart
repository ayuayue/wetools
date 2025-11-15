import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepLTranslator {
  static const String _endpoint = "https://api.deeplx.org/GrsQtQjzGxiuxock-cNP-nPZrX1hmSeZ8pXQg5JislM/translate";
  // static const String _endpoint = "https://deeplx.caoayu.top/translate";

  Future<String> translate(
    String text, {
    String from = 'auto',
    required String to,
  }) async {
    if (text.isEmpty) return '';

    // DeepL 语言代码转换
    String sourceLang = from == 'auto' ? 'auto' : _convertLanguageCode(from);
    String targetLang = _convertLanguageCode(to);

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': text,
          'source_lang': sourceLang,
          'target_lang': targetLang,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200) {
          return result['data'];
        } else {
          throw Exception('DeepLX API错误: ${result['message'] ?? '未知错误'}');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(
            '翻译请求失败(${response.statusCode}): ${error['message'] ?? response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('翻译出错: $e');
    }
  }

  String _convertLanguageCode(String code) {
    // 将语言代码转换为 DeepL 支持的格式
    switch (code.toLowerCase()) {
      case 'zh-cn':
        return 'ZH';
      case 'en':
        return 'EN';
      case 'ja':
        return 'JA';
      case 'ko':
        return 'KO';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      case 'es':
        return 'ES';
      case 'ru':
        return 'RU';
      default:
        return code.toUpperCase();
    }
  }
}

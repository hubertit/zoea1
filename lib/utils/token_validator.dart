import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/apik.dart';
import '../services/api_key_manager.dart';

class TokenValidator {
  static const String _openAIBaseUrl = 'https://api.openai.com/v1';
  
  /// Validates the OpenAI API token by making a simple test request
  static Future<bool> validateOpenAIToken() async {
    try {
      final apiKey = await ApiKeyManager.getOpenAIKey();
      final response = await http.post(
        Uri.parse('$_openAIBaseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'user', 'content': 'Hello'}
          ],
          'max_tokens': 10,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'] != null && data['choices'].isNotEmpty;
      } else if (response.statusCode == 401) {
        print('Token validation failed: Unauthorized (401)');
        return false;
      } else {
        print('Token validation failed: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }
  
  /// Gets detailed information about the token validation
  static Future<Map<String, dynamic>> getTokenInfo() async {
    try {
      final apiKey = await ApiKeyManager.getOpenAIKey();
      final response = await http.get(
        Uri.parse('$_openAIBaseUrl/models'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );
      
      if (response.statusCode == 200) {
        return {
          'valid': true,
          'status': 'Token is valid',
          'models_available': true,
        };
      } else if (response.statusCode == 401) {
        return {
          'valid': false,
          'status': 'Token is invalid or expired',
          'error': 'Unauthorized (401)',
        };
      } else {
        return {
          'valid': false,
          'status': 'Token validation failed',
          'error': 'Status ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'valid': false,
        'status': 'Network error',
        'error': e.toString(),
      };
    }
  }
}

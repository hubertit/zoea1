import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ConfigService {
  static const String _configUrl = 'https://zoea.africa/api/configs/';
  
  static Map<String, dynamic>? _cachedConfig;
  static DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 30); // Cache for 30 minutes

  /// Fetch configuration from server
  static Future<Map<String, dynamic>> fetchConfig({String? platform}) async {
    try {
      // Check if we have valid cached config
      if (_cachedConfig != null && _lastFetchTime != null) {
        final timeSinceLastFetch = DateTime.now().difference(_lastFetchTime!);
        if (timeSinceLastFetch < _cacheDuration) {
          debugPrint('Using cached config');
          return _cachedConfig!;
        }
      }

      // Build URL with platform parameter if specified
      final uri = platform != null 
          ? Uri.parse('$_configUrl?platform=$platform')
          : Uri.parse(_configUrl);

      debugPrint('Fetching config from: $uri');

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Config fetch timeout');
        },
      );

      if (response.statusCode == 200) {
        final config = json.decode(response.body) as Map<String, dynamic>;
        
        // Cache the config
        _cachedConfig = config;
        _lastFetchTime = DateTime.now();
        
        debugPrint('Config fetched successfully');
        return config;
      } else {
        throw Exception('Failed to fetch config: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching config: $e');
      
      // Return fallback config if fetch fails
      return _getFallbackConfig();
    }
  }

  /// Get specific API key
  static Future<String?> getApiKey(String keyName, {String? platform}) async {
    try {
      final config = await fetchConfig(platform: platform);
      
      switch (keyName.toLowerCase()) {
        case 'openai':
          return config['openAIKey'] as String?;
        case 'googlemaps':
        case 'maps':
          return config['googleMapsKey'] as String?;
        case 'firebase':
          if (platform != null && config['firebaseKey'] != null) {
            final firebaseConfig = config['firebaseKey'] as Map<String, dynamic>;
            return firebaseConfig['apiKey'] as String?;
          }
          return null;
        case 'payment':
          return config['paymentKey'] as String?;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error getting API key $keyName: $e');
      return null;
    }
  }

  /// Get Firebase configuration for current platform
  static Future<Map<String, dynamic>?> getFirebaseConfig() async {
    try {
      String platform = 'android'; // Default
      
      if (kIsWeb) {
        platform = 'web';
      } else {
        // You can add platform detection logic here
        // For now, we'll use a simple approach
        platform = 'android'; // or 'ios' based on your needs
      }
      
      final config = await fetchConfig(platform: platform);
      return config['firebaseKey'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Error getting Firebase config: $e');
      return null;
    }
  }

  /// Get base URLs
  static Future<Map<String, String>> getBaseUrls() async {
    try {
      final config = await fetchConfig();
      return {
        'baseUrl': config['baseUrl'] as String? ?? 'https://zoea.africa/',
        'catalogUrl': config['catalogUrl'] as String? ?? 'https://zoea.africa/catalog/',
      };
    } catch (e) {
      debugPrint('Error getting base URLs: $e');
      return {
        'baseUrl': 'https://zoea.africa/',
        'catalogUrl': 'https://zoea.africa/catalog/',
      };
    }
  }

  /// Clear cached config (useful for testing or force refresh)
  static void clearCache() {
    _cachedConfig = null;
    _lastFetchTime = null;
    debugPrint('Config cache cleared');
  }

  /// Fallback configuration if server is unavailable
  static Map<String, dynamic> _getFallbackConfig() {
    return {
      'baseUrl': 'https://zoea.africa/',
      'catalogUrl': 'https://zoea.africa/catalog/',
      'googleMapsKey': 'YOUR_GOOGLE_MAPS_API_KEY_HERE',
      'openAIKey': 'YOUR_OPENAI_API_KEY_HERE',
      'paymentKey': 'YOUR_PAYMENT_GATEWAY_KEY',
      'timestamp': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'isFallback': true,
    };
  }
}

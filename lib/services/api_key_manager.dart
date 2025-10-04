import 'package:flutter/foundation.dart';
import 'config_service.dart';

class ApiKeyManager {
  static ApiKeyManager? _instance;
  static ApiKeyManager get instance => _instance ??= ApiKeyManager._internal();
  
  ApiKeyManager._internal();

  // Cache for API keys
  String? _openAIKey;
  String? _googleMapsKey;
  String? _googleAPIKey;
  Map<String, dynamic>? _firebaseConfig;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

  /// Initialize API keys (call this in main.dart)
  static Future<void> initialize() async {
    try {
      debugPrint('🔑 Initializing API Key Manager...');
      
      // Fetch all keys in parallel
      await Future.wait([
        instance._fetchOpenAIKey(),
        instance._fetchGoogleMapsKey(),
        instance._fetchGoogleAPIKey(),
        instance._fetchFirebaseConfig(),
      ]);
      
      debugPrint('✅ API Key Manager initialized successfully');
    } catch (e) {
      debugPrint('⚠️ API Key Manager initialization failed: $e');
      // Continue with fallback keys
    }
  }

  /// Get OpenAI API Key
  static Future<String> getOpenAIKey() async {
    if (instance._openAIKey != null && instance._isCacheValid()) {
      return instance._openAIKey!;
    }
    return await instance._fetchOpenAIKey();
  }

  /// Get Google Maps API Key
  static Future<String> getGoogleMapsKey() async {
    if (instance._googleMapsKey != null && instance._isCacheValid()) {
      return instance._googleMapsKey!;
    }
    return await instance._fetchGoogleMapsKey();
  }

  /// Get Google API Key (for other Google services)
  static Future<String> getGoogleAPIKey() async {
    if (instance._googleAPIKey != null && instance._isCacheValid()) {
      return instance._googleAPIKey!;
    }
    return await instance._fetchGoogleAPIKey();
  }

  /// Get Firebase Configuration
  static Future<Map<String, dynamic>?> getFirebaseConfig() async {
    if (instance._firebaseConfig != null && instance._isCacheValid()) {
      return instance._firebaseConfig;
    }
    return await instance._fetchFirebaseConfig();
  }

  /// Get Base URLs
  static Future<Map<String, String>> getBaseUrls() async {
    try {
      return await ConfigService.getBaseUrls();
    } catch (e) {
      debugPrint('⚠️ Failed to fetch base URLs: $e');
      return {
        'baseUrl': 'https://zoea.africa/',
        'catalogUrl': 'https://zoea.africa/catalog/',
      };
    }
  }

  /// Get API Base URL
  static Future<String> getApiBaseUrl() async {
    try {
      final urls = await ConfigService.getBaseUrls();
      return urls['baseUrl'] ?? 'https://zoea.africa/';
    } catch (e) {
      return 'https://zoea.africa/';
    }
  }

  /// Clear cache (useful for testing or force refresh)
  static void clearCache() {
    instance._openAIKey = null;
    instance._googleMapsKey = null;
    instance._googleAPIKey = null;
    instance._firebaseConfig = null;
    instance._lastFetchTime = null;
    debugPrint('🗑️ API Key Manager cache cleared');
  }

  // Private methods for fetching keys
  Future<String> _fetchOpenAIKey() async {
    try {
      final key = await ConfigService.getApiKey('openai');
      if (key != null) {
        _openAIKey = key;
        _lastFetchTime = DateTime.now();
        debugPrint('✅ OpenAI key fetched from server');
        return key;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to fetch OpenAI key: $e');
    }
    
    // Fallback to local key
    return 'YOUR_OPENAI_API_KEY_HERE';
  }

  Future<String> _fetchGoogleMapsKey() async {
    try {
      final key = await ConfigService.getApiKey('googlemaps');
      if (key != null) {
        _googleMapsKey = key;
        _lastFetchTime = DateTime.now();
        debugPrint('✅ Google Maps key fetched from server');
        return key;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to fetch Google Maps key: $e');
    }
    
    // Fallback to local key
    return 'AIzaSyCd8042Lj-wdIbCWAsvRp-FctZh3rKKS-s';
  }

  Future<String> _fetchGoogleAPIKey() async {
    try {
      final key = await ConfigService.getApiKey('googlemaps');
      if (key != null) {
        _googleAPIKey = key;
        _lastFetchTime = DateTime.now();
        debugPrint('✅ Google API key fetched from server');
        return key;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to fetch Google API key: $e');
    }
    
    // Fallback to local key
    return 'AIzaSyAgU_8Z_hG2iWAL6K9QDdqdmes_YjFSK3s';
  }

  Future<Map<String, dynamic>?> _fetchFirebaseConfig() async {
    try {
      final config = await ConfigService.getFirebaseConfig();
      if (config != null) {
        _firebaseConfig = config;
        _lastFetchTime = DateTime.now();
        debugPrint('✅ Firebase config fetched from server');
        return config;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to fetch Firebase config: $e');
    }
    
    return null;
  }

  bool _isCacheValid() {
    if (_lastFetchTime == null) return false;
    final timeSinceLastFetch = DateTime.now().difference(_lastFetchTime!);
    return timeSinceLastFetch < _cacheDuration;
  }
}

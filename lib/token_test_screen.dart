import 'package:flutter/material.dart';
import 'utils/token_validator.dart';
import 'constants/theme.dart';

class TokenTestScreen extends StatefulWidget {
  const TokenTestScreen({super.key});

  @override
  State<TokenTestScreen> createState() => _TokenTestScreenState();
}

class _TokenTestScreenState extends State<TokenTestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _tokenInfo;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final info = await TokenValidator.getTokenInfo();
      setState(() {
        _tokenInfo = info;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _tokenInfo = {
          'valid': false,
          'status': 'Error occurred',
          'error': e.toString(),
        };
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Token Test'),
        backgroundColor: kBlack,
        foregroundColor: kWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _checkToken,
          ),
        ],
      ),
      body: Container(
        color: scaffoldColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isLoading 
                            ? Icons.hourglass_empty
                            : (_tokenInfo?['valid'] == true 
                                ? Icons.check_circle 
                                : Icons.error),
                          color: _isLoading 
                            ? Colors.orange
                            : (_tokenInfo?['valid'] == true 
                                ? Colors.green 
                                : Colors.red),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isLoading 
                            ? 'Checking token...'
                            : (_tokenInfo?['valid'] == true 
                                ? 'Token is Valid' 
                                : 'Token is Invalid'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_tokenInfo != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Status: ${_tokenInfo!['status']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (_tokenInfo!['error'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${_tokenInfo!['error']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      if (_tokenInfo!['models_available'] == true) ...[
                        const SizedBox(height: 8),
                        const Text(
                          '✅ Models are accessible',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What this means:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• If the token is valid, the chatbot should work normally\n'
                      '• If the token is invalid, you\'ll see error messages in the chat\n'
                      '• Invalid tokens usually mean the API key has expired or been revoked\n'
                      '• Contact the development team to update the API key',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlack,
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(kWhite),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Checking...'),
                        ],
                      )
                    : const Text('Test Token Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

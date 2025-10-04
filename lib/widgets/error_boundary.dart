import 'dart:io';
import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.onError,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      widget.onError?.call(details.exception, details.stack ?? StackTrace.empty);
      
      // Get the error message
      String errorMessage = _getErrorMessage(details.exception);
      bool isImageError = _isImageLoadingError(details.exception);
      
      if (isImageError) {
        // Just log image errors
        debugPrint('Image loading error: $errorMessage');
      } else {
        // Use post-frame callback to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
                        _hasError = true;
            });
          }
        });
      }
    };
  }

  String _getErrorMessage(Object error) {
    if (error is HttpException) {
      if (error.toString().contains('404')) {
        return 'Failed to load image: Image not found';
      }
      return 'Network error: ${error.message}';
    } else if (error is NetworkImageLoadException) {
      return 'Failed to load image: ${error.statusCode}';
    } else if (error is FormatException) {
      return 'Invalid data format: ${error.message}';
    } else if (error is TypeError) {
      return 'Type error: Unexpected data type';
    } else if (error is StateError) {
      return 'State error: ${error.message}';
    } else {
      return 'Error: ${error.toString()}';
    }
  }

  bool _isImageLoadingError(Object error) {
    return error.toString().contains('Failed host lookup') ||
           error.toString().contains('404') ||
           error.toString().contains('Connection failed') ||
           error.toString().contains('NetworkImage') ||
           error is NetworkImageLoadException;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The app encountered an error and needs to restart.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}

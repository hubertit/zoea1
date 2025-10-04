import 'package:flutter/material.dart';
import 'dart:ui';

enum SnackBarType {
  info,
  warning,
  error,
  success,
}

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _CustomSnackBarContent(
          message: message,
          type: type,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Convenience methods for different types
  static void showInfo(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.info);
  }

  static void showWarning(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.warning);
  }

  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.success);
  }
}

class _CustomSnackBarContent extends StatelessWidget {
  final String message;
  final SnackBarType type;

  const _CustomSnackBarContent({
    required this.message,
    required this.type,
  });

  Color _getTextColor() {
    switch (type) {
      case SnackBarType.info:
        return const Color(0xFF2196F3); // Blue
      case SnackBarType.warning:
        return const Color(0xFFFF9800); // Orange
      case SnackBarType.error:
        return const Color(0xFFF44336); // Red
      case SnackBarType.success:
        return const Color(0xFF4CAF50); // Green
    }
  }

  IconData _getIcon() {
    switch (type) {
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                _getIcon(),
                color: _getTextColor(),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: _getTextColor(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

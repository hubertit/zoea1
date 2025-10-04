import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/style_utls.dart';

import 'ults/functions.dart';

class FeedbackBottomDialog extends StatefulWidget {
  const FeedbackBottomDialog({
    super.key,
  });

  @override
  State<FeedbackBottomDialog> createState() => _FeedbackBottomDialogState();
}

class _FeedbackBottomDialogState extends Superbase<FeedbackBottomDialog> 
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _loading = false;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "app/addReview",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user!.token,
            "rating": _rating,
            "review": _reviewController.text
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              goBack();
              showMessageSnack(obj);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A1A1A)
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        


                        // Rating Section
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                "Rate your experience",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Star Rating
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _rating = index + 1;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(
                                        index < _rating ? Icons.star : Icons.star_border,
                                        size: 45,
                                        color: index < _rating
                                            ? Colors.amber
                                            : (Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white38
                                                : Colors.grey.shade400),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              
                              // Rating Text
                              if (_rating > 0) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _getRatingText(_rating),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Review Section
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tell us more (optional)",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _reviewController,
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                cursorColor: Theme.of(context).primaryColor,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: "Share your thoughts about Zoea...",
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? const Color(0xFFB3B3B3)
                                        : const Color(0xFF616161),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF2A2A2A)
                                      : Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Submit Button
                        Container(
                          padding: const EdgeInsets.all(24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: _loading
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: _rating > 0 ? submit : null,
                                    child: Text(
                                      "Submit Feedback",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Bottom padding for safe area
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent";
      default:
        return "";
    }
  }
}

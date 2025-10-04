import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ConversationButton extends StatefulWidget{
  final VoidCallback voidCallback;
  const ConversationButton({super.key, required this.voidCallback});

  @override
  State<ConversationButton> createState() => _ConversationButtonState();
}

class _ConversationButtonState extends State<ConversationButton> {

  final radius = BorderRadius.circular(1000);

  Color borderColor = const Color(0xffE3E7EC);

  Timer? _timer;

  @override
  void initState(){
    super.initState();
    _startColorAnimation();
  }

  void _startColorAnimation() {
    try {
      _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        if (mounted) {
          setState(() {
            borderColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
          });
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      print('Error starting color animation: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: radius
      ),
      child: Material(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: radius),
        child: InkWell(
          onTap: widget.voidCallback,
          child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Stack(
                  children: [
                    const Icon(
                      AntDesign.message1,
                      size: 20,
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          // Provide an optional curve to make the animation feel smoother.
                          curve: Curves.fastOutSlowIn,
                          decoration: BoxDecoration(
                              color: borderColor,
                              shape: BoxShape.circle),
                          width: 10,
                          height: 10,
                        ))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
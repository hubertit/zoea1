import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundBlur extends StatelessWidget {
  Widget? screens;
  double paddingSize;

  BackgroundBlur({Key? key, this.screens, required this.paddingSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(radius: 10,
          backgroundColor: Colors.transparent,
          child: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
                top: 150,
                left: 250,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(color: Color(0xFFE1CF24)),
                )),
            Positioned(
                top: 30,
                left: 60,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                )),
            Positioned(
                top: 200,
                left: -80,
                child: Container(
                  height: 200,
                  width: 100,
                  decoration:  BoxDecoration(color: Theme.of(context).primaryColor),
                )),
            Container(
              height: MediaQuery.of(context).size.height,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 90.0),
                child: Container(
                  color: Colors.white.withOpacity(.0),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: screens,
              ),
            )
          ],
        ),
      ),
    );
  }
}

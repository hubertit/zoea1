import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/homepage.dart';

import '../../partial/cover_container.dart';
import '../auth/widgets/auth_btn.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          height: MediaQuery.of(context).size.height / 1.2,
          child: Column(
            children: [
              CoverContainer(children: [
                Center(
                  child: Image.asset(
                    'assets/images/success.png',
                    height: 40,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Thank you for booking accommodation with us, we are reviewing your payment information and we will get back to you soon',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16,),textAlign: TextAlign.center,),
                const SizedBox(
                  height: 30,
                ),
              ]),

              // Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: AuthButton(onPressed: ()  {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Homepage()));
                }, text: "Continue"),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

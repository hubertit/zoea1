import 'package:flutter/material.dart';

import '../../homepage.dart';
import '../../partial/cover_container.dart';
import '../auth/widgets/auth_btn.dart';



class FailedScreen extends StatefulWidget {
  const FailedScreen({super.key});

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends State<FailedScreen> {
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
                    'assets/images/failed.png',
                    height: 40,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: const Text('Your membership activation has been failed',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ),
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
                }, text: "Try again"),
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

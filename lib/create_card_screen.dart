import 'package:flutter/material.dart';

class CreateCardScreen extends StatefulWidget{
  const CreateCardScreen({super.key});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Card"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Card Number",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Card Number"
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Card Holder Name",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Card Holder Name"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text("Expired",style: TextStyle(
                            color: Color(0xff78828A),
                            fontSize: 16
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "MM/YY"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text("CVV code",style: TextStyle(
                            color: Color(0xff78828A),
                            fontSize: 16
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "CVV"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: (){}, child: const Text("Add Card"))
        ],
      ),
    );
  }
}
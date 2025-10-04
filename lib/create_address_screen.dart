import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

class CreateAddressScreen extends StatefulWidget{
  const CreateAddressScreen({super.key});

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends Superbase<CreateAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Address"),),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Full Name",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Full Name / Home / Office "
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Country",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownButtonFormField(
              items: const [],
              onChanged: (v){},
              decoration: const InputDecoration(
                  hintText: "Select Country"
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("City",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownButtonFormField(
              items: const [],
              onChanged: (v){},
              decoration: const InputDecoration(
                  hintText: "Select City"
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("State",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownButtonFormField(
              items: const [],
              onChanged: (v){},
              decoration: const InputDecoration(
                  hintText: "Select State"
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Zip Code",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              validator: validateRequired,
              decoration: const InputDecoration(
                  hintText: "Enter your Zip Code"
              )
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Location",style: TextStyle(
                color: Color(0xff78828A),
                fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: TextFormField(
              validator: validateRequired,
              decoration: const InputDecoration(
                  hintText: "Enter your Address"
              ),minLines: 5,maxLines: 7,
            ),
          ),
          ElevatedButton(onPressed: (){}, child: const Text("Save Address"))
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:zoea1/create_address_screen.dart';
import 'package:zoea1/super_base.dart';

class AddressesScreen extends StatefulWidget{
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends Superbase<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    var color = const Color(0xff2196F3);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                    )
                ),
                color: Colors.white,
                child: InkWell(
                  onTap: (){
                    push(const CreateAddressScreen());
                  },
                  child: SizedBox(
                      height: 30,
                      width: 30,child: Icon(Icons.add,color: Colors.grey.shade400,size: 19,)),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (context,index){
        var checked = index%2==0;
        return InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Andy Andrew",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),),
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("+1 234 567 890",style: TextStyle(
                        color: Color(0xff78828A)
                      ),),
                    ),
                    const Text("1234 Your Road No #6789 Your City, Country",style: TextStyle(
                        color: Color(0xff78828A)
                    ),),
                    OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),   side: BorderSide(
                        color: color
                    ),
                      foregroundColor: color
                    ), child: const Text("Change Address"))
                  ],
                )),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: color
                      ),
                      color: checked ? color : null,
                      shape: BoxShape.circle
                  ),
                  child: checked ? const Icon(Icons.check,color: Colors.white,size: 19,) : null,
                )
              ],
            ),
          ),
        );
      },itemCount: 1000,),
    );
  }
}
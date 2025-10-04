import 'package:flutter/material.dart';
import 'package:zoea1/create_card_screen.dart';
import 'package:zoea1/super_base.dart';

class PaymentsScreen extends StatefulWidget{
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends Superbase<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Payments"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    )
                ),
                color: Colors.white,
                child: InkWell(
                  onTap: (){
                    push(const CreateCardScreen());
                  },
                  child: SizedBox(
                      height: 30,
                      width: 30,child: Icon(Icons.add,color: Colors.grey.shade700,size: 19,)),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (context,index){
        var checked = index%2==0;
        var image = checked ? "visa.png" : "master.png";
        return InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20).copyWith(bottom: 0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    shape: BoxShape.circle
                  ),
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(12),
                  child: Image(
                    image: AssetImage("assets/$image"),
                  ),
                ),
                 Expanded(child: Container(
                   decoration: BoxDecoration(
                     border: Border(
                       bottom: BorderSide(
                         color: Colors.grey.shade200
                       )
                     )
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 15),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("BCA (Bank of Kigali)",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text("•••• •••• •••• 12345",style: TextStyle(
                                    color: Color(0xff78828A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16
                                ),),
                              ),
                              Text("Kigali, Rwanda",style: TextStyle(
                                  color: Color(0xff78828A)
                              ),),
                            ],
                          ),
                        ),
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
                ))
              ],
            ),
          ),
        );
      },itemCount: 1000,),
    );
  }
}
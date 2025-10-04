import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'super_base.dart';

import 'json/event.dart';
import 'json/ticket.dart';
import 'json/user.dart';

class TicketCheckoutScreen extends StatefulWidget{
  final Event event;
  final Ticket ticket;
  const TicketCheckoutScreen({super.key, required this.event, required this.ticket});

  @override
  State<TicketCheckoutScreen> createState() => _TicketCheckoutScreenState();
}

class _TicketCheckoutScreenState extends Superbase<TicketCheckoutScreen> {
  String? _checked;

  Widget buildPayment(String type,String image,String number){

    bool checked = type == _checked;

    return
      OutlinedButton(onPressed: (){
        setState(() {
          _checked = type;
        });
      },style: OutlinedButton.styleFrom(
        side: checked ? BorderSide(
          color: Theme.of(context).primaryColor
        ) : null
      ), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/$image",height: 50,width: 50,),
          ),
          Text(number),
          checked ? const Icon(Icons.check_circle) : const SizedBox(width: 25,)
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Image(image: CachedNetworkImageProvider(widget.event.poster),width: 90,height: 90,fit: BoxFit.cover,),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.w700,
                          fontSize: 17),
                    ),
                    Text(widget.event.address,style: const TextStyle(
                        color: Color(0xffBF1919),
                        fontSize: 16
                    ),),
                  ],
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text("Customer Info",style: Theme.of(context).appBarTheme.titleTextStyle,),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Name :",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 18
                ),)),
                Text(User.user?.display??"",style: const TextStyle(
                  fontSize: 18
                ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Phone :",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 18
                ),)),
                Text(User.user?.phone??"",style: const TextStyle(
                  fontSize: 18
                ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text("Order Info",style: Theme.of(context).appBarTheme.titleTextStyle,),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Ticket :",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 18
                ),)),
                Text(widget.ticket.name,style: const TextStyle(
                  fontSize: 18
                ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Quantity :",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 18
                ),)),
                Text(fmtNbr(widget.ticket.newQty),style: const TextStyle(
                  fontSize: 18
                ),)
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Total :",style: TextStyle(
                    color: Color(0xff78828A),
                    fontSize: 18
                ),)),
                Text("${fmtNbr(widget.ticket.total)} USD",style: const TextStyle(
                    fontSize: 18
                ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text("Promo Code",style: Theme.of(context).appBarTheme.titleTextStyle,),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Input Here ...",
              suffixIcon: ElevatedButton(style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal:35)
              ),onPressed: (){}, child: const Text("Apply"))
            ),
          ),     const Padding(
            padding: EdgeInsets.only(bottom: 5,top: 15),
            child: Row(
              children: [
                Expanded(child: Text("Promo :",style: TextStyle(
                    color: Color(0xff78828A),
                    fontSize: 18
                ),)),
                Text("-0",style: TextStyle(
                    fontSize: 18,
                  color: Colors.red
                ),)
              ],
            ),
          ),
          const Divider(),          Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 10),
            child: Row(
              children: [
                const Expanded(child: Text("Total Pay:",style: TextStyle(
                    color: Color(0xff78828A),
                    fontSize: 18
                ),)),
                Text("${fmtNbr(widget.ticket.total)} USD",style: const TextStyle(
                    fontSize: 18
                ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text("Payment Mode",style: Theme.of(context).appBarTheme.titleTextStyle,),
          ),
          buildPayment("visa", "visa.png", "•••• •••• •••• 87652"),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buildPayment("master", "master.png", "•••• •••• •••• 87652"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(onPressed: (){}, child: const Text("Pay Now")),
          )
        ],
      ),
    );
  }
}
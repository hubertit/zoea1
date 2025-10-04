import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'json/event.dart';
import 'json/ticket.dart';
import 'super_base.dart';
import 'ticket_checkout_screen.dart';
import 'utils/number_formatter.dart';

class TicketPaymentDialog extends StatefulWidget{
  final Ticket ticket;
  final Event event;
  const TicketPaymentDialog({super.key, required this.ticket, required this.event});

  @override
  State<TicketPaymentDialog> createState() => _TicketPaymentDialogState();
}

class _TicketPaymentDialogState extends Superbase<TicketPaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.close)),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Text("Booking",textAlign: TextAlign.center,style: Theme.of(context).appBarTheme.titleTextStyle,),
                ))
              ],
            ),
            Row(
              children: [
                Image(image: CachedNetworkImageProvider(widget.event.poster),width: 90,height: 90,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.w700,
                          fontSize: 17),
                    ),
                    Text(NumberFormatter.formatCurrencyWithCode(widget.ticket.price, 'USD'),style: const TextStyle(
                      color: Color(0xffBF1919),
                      fontSize: 16
                    ),),
                    Row(
                      children: [
                        const Expanded(
                          child: Text("Quantity : ",style: TextStyle(
                            color: Color(0xff616161),
                            fontSize: 17
                          ),),
                        ),
                        IconButton(onPressed: (){
                          if(widget.ticket.newQty>1) {
                            setState(() {
                              widget.ticket.newQty--;
                          });
                          }
                        }, icon: const Icon(Icons.remove_circle)),
                        Chip(label: Text(NumberFormatter.formatNumber(widget.ticket.newQty))),
                        IconButton(onPressed: (){
                          if(widget.ticket.newQty<widget.ticket.qty) {
                            setState(() {
                              widget.ticket.newQty++;
                          });
                          }
                        }, icon: const Icon(Icons.add)),
                      ],
                    )
                  ],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(onPressed: (){
                push(TicketCheckoutScreen(event: widget.event, ticket: widget.ticket));
              }, child: Text("PAY NOW (${NumberFormatter.formatCurrency(widget.ticket.total)})")),
            )
          ],
        ),
      ),
    );
  }
}
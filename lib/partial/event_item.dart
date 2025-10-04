import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/main.dart';

import '../event_details_screen.dart';
import '../json/event.dart';
import '../super_base.dart';

class EventItem extends StatefulWidget{
  final Event event;
  final bool showStatus;
  const EventItem({super.key, required this.event, this.showStatus = true});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends Superbase<EventItem> {
  @override
  Widget build(BuildContext context) {
    var card = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)
      ),
      shadowColor: Colors.black26,
      margin: const EdgeInsets.all(0).copyWith(right: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: (){
          push(EventDetailsScreen(event: widget.event));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: widget.event.poster,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(widget.event.name,maxLines: 1,style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),),
                  Text(widget.event.startDate,style: const TextStyle(
                      // color: Color(0xffF2A034),
                      // fontWeight: FontWeight.w400,
                      fontSize: 11
                  ),),
                  Text(widget.event.address,maxLines: 1,style:  TextStyle(
                      fontSize: 13,
                      color: primaryColor
                  ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return SizedBox(
      width: 170,
      child: widget.event.categoryName != null ? Stack(
        children: [
          card,
          Positioned(right: 20,top: 20,child: Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Text(widget.event.categoryName!,style: const TextStyle(
              color: Color(0xffFBC02D),fontWeight: FontWeight.w500,fontSize: 16
            ),),
          ))
        ],
      ) : card,
    );
  }
}
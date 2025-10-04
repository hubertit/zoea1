import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import '../json/place.dart';

class PlaceTourItem extends StatefulWidget{
  final Place place;
  const PlaceTourItem({super.key, required this.place});

  @override
  State<PlaceTourItem> createState() => _PlaceTourItemState();
}

class _PlaceTourItemState extends Superbase<PlaceTourItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: (){
          push(PlaceDetailScreen(place: widget.place));
        },
        child: SizedBox(
          width: 280,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: widget.place.image != null ? DecorationImage(fit: BoxFit.cover,image: CachedNetworkImageProvider(widget.place.image!)) : null,
                          color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 13),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,color: Colors.yellow.shade600,size: 16,),
                            const SizedBox(width: 4),
                            Text("${widget.place.rating}",style: const TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13,left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(widget.place.title,style: Theme.of(context).appBarTheme.titleTextStyle,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: RichText(text:TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.location_on_sharp,size: 16,color: smallTextColor,)),
                              TextSpan(text: widget.place.location,style: TextStyle(
                                  color: smallTextColor
                              ))
                            ]
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(widget.place.currency,style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
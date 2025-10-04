import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import '../json/place.dart';

class PlaceDetailItem extends StatefulWidget{
  final Place place;
  const PlaceDetailItem({super.key, required this.place});

  @override
  State<PlaceDetailItem> createState() => _PlaceDetailItemState();
}

class _PlaceDetailItemState extends Superbase<PlaceDetailItem> {
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
          width: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: widget.place.image != null ? DecorationImage(image: CachedNetworkImageProvider(widget.place.image!),fit: BoxFit.cover) : null,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 13),
                    ),
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
                        child: Text(widget.place.title,maxLines: 2,overflow: TextOverflow.ellipsis,style: Theme.of(context).appBarTheme.titleTextStyle,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text("3days 2nights, ${widget.place.currency}",maxLines: 1,style: const TextStyle(
                            fontSize: 14,
                        ),),
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
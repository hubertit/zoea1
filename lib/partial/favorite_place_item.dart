import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import '../json/place.dart';

class FavoritePlaceItem extends StatefulWidget{
  final Place place;
  const FavoritePlaceItem({super.key, required this.place});

  @override
  State<FavoritePlaceItem> createState() => _FavoritePlaceItemState();
}

class _FavoritePlaceItemState extends Superbase<FavoritePlaceItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (){
          push(PlaceDetailScreen(place: widget.place,));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: widget.place.image != null ? DecorationImage(fit: BoxFit.cover,image: CachedNetworkImageProvider(widget.place.image!)) : null,
                color: Colors.grey.shade400
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.place.title,overflow: TextOverflow.ellipsis,style: Theme.of(context).appBarTheme.titleTextStyle,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  widget.place.hasPrice ? Expanded(
                    child: Text(widget.place.currency,style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),),
                  ) : const SizedBox.shrink(),
                  Icon(Icons.star,color: Colors.yellow.shade600,size: 18,),
                  Text("${widget.place.rating}",style: TextStyle(
                      color: Colors.yellow.shade600
                  ),),
                  Text(widget.place.number > 0 ? "(${widget.place.number} reviews)" : "")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
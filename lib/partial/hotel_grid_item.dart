import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/utils/number_formatter.dart';

import '../json/hotel.dart';

class HotelGridItem extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback? callback;
  const HotelGridItem({super.key, required this.hotel, this.callback});

  @override
  State<HotelGridItem> createState() => _HotelGridItemState();
}

class _HotelGridItemState extends Superbase<HotelGridItem> {
  void changeFavorite() async {
    // if(widget.hotel.adding){
    //   return;
    // }
    //
    // setState(() {
    //   widget.hotel.adding = true;
    // });
    // await ajax(url: "others/favorites",method: "POST",data: FormData.fromMap(
    //     {
    //       "venue_id":widget.hotel.id,
    //       "action":widget.hotel.favorite ? "remove" : "add"
    //     }),onValue: (obj,url){
    //   if(obj['code'] == 200){
    //     setState(() {
    //       widget.hotel.favorite = !widget.hotel.favorite;
    //     });
    //   }
    // });
    // setState(() {
    //   widget.hotel.adding = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var hasHeight = cons.maxHeight.isFinite;

      Widget item = Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8)),
            height: hasHeight ? null : 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.hotel.banner,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 30,
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
          ),
          // Positioned(
          //   top: 8,
          //   right: 8,
          //   child: Card(
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(1000)
          //     ),
          //     child: InkWell(
          //       onTap: changeFavorite,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: widget.hotel.adding ? const CupertinoActivityIndicator() : Icon(widget.hotel.favorite ? Icons.favorite : Icons.favorite_border,color: widget.hotel.favorite ? Colors.red : null,),
          //       ),
          //     ),
          //   ),
          // )
        ],
      );

      if (hasHeight) {
        item = Expanded(child: item);
      }

      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.callback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            item,
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.hotel.name,
                maxLines: hasHeight ? 1 : null,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.location_on_sharp,
                      size: 16,
                      color: smallTextColor,
                    )),
                    TextSpan(
                        text: widget.hotel.address,
                        style: TextStyle(color: smallTextColor))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      NumberFormatter.formatHotelPrice(widget.hotel.minPrice),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 18,
                  ),
                  Text(
                    "${widget.hotel.star}",
                    style: TextStyle(color: Colors.yellow.shade600),
                  ),
                  // Text("(${widget.hotel.star})")
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../json/review.dart';

class ReviewItem extends StatefulWidget{
  final Review review;
  const ReviewItem({super.key, required this.review});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.review.user.profile != null ? CachedNetworkImageProvider(widget.review.user.profile!) : null,
          backgroundColor: Colors.grey.shade500,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(widget.review.names,style: Theme.of(context).appBarTheme.titleTextStyle,),
                        Row(children: List.generate(5, (index) => Icon(widget.review.rating > index ? Icons.star : Icons.star_border,color: Colors.yellow.shade600,size: 19,)),)
                      ],
                    )),
                     Text(widget.review.date,style: const TextStyle(
                        color: Color(0xff9CA4AB),
                        fontSize: 16
                    ),),
                  ],
                ),
                 Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(widget.review.comment,style: const TextStyle(
                      fontSize: 15
                  ),),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

import '../event_details_screen.dart';
import '../events_screen.dart';
import '../json/event.dart';

// ignore: must_be_immutable
class BreakingNewsCard extends StatefulWidget {
  BreakingNewsCard(this.data, {Key? key}) : super(key: key);
  Event data;
  @override
  State<BreakingNewsCard> createState() => _BreakingNewsCardState();
}

class _BreakingNewsCardState extends Superbase<BreakingNewsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        push(EventDetailsScreen(event: widget.data));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailsScreen(widget.data),
        //     ));
      },
      child: Container(
        width: 900,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),

          image: DecorationImage(
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(widget.data.poster!),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: const LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.address!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),

              Text(
                widget.data.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),

              Text(
                widget.data.startTime!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
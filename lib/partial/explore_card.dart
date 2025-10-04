import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String icon;
  const ExploreCard(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 115,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                // height: 83,
                child: Center(
                    child: CachedNetworkImage(
                  imageUrl: icon,
                  height: 40,
                )),
              ),
            ),
            Container(
              height: 30,
              width: 150,
              color: const Color(0xffe7e4e4),
              child: Center(
                  child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black),
              )),
            )
          ],
        ),
      ),
    );
  }
}

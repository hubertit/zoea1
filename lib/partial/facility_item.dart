import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

import '../json/facility.dart';

class FacilityItem extends StatefulWidget{
  final Facility facility;
  const FacilityItem({super.key, required this.facility});

  @override
  State<FacilityItem> createState() => _FacilityItemState();
}

class _FacilityItemState extends Superbase<FacilityItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000)),
            color: Theme
                .of(context)
                .inputDecorationTheme
                .fillColor,
            child: InkWell(
              onTap: () {
                // push(ServiceDetailScreen(service: e));
              },
              child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset('assets/${widget.facility.image}',errorBuilder: errorBuilder,)),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            widget.facility.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xff78828A),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
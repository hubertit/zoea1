// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:melamart/models/store.dart';
// import 'package:melamart/theme/colors.dart';
//
//
// class StoreCard extends StatefulWidget {
//   final Store store;
//   final VoidCallback? callback;
//   final double? imageHeight;
//   final EdgeInsets? padding;
//   final bool fromBooking;
//   final String? category;
//   const StoreCard(
//       {super.key,
//         required this.store,
//         this.callback,
//         this.imageHeight,
//         this.padding,
//         this.fromBooking = false,
//         this.category});
//
//   @override
//   State<StoreCard> createState() => _StoreCardState();
// }
//
// bool canLike = true;
//
// class _StoreCardState extends State<StoreCard> {
//
//   @override
//   Widget build(BuildContext context) {
//     var colorAvatar = const Color(0xcbebf8ef);
//     return Container(
//       margin: widget.padding ?? const EdgeInsets.only(bottom: 7.5),
//       padding: widget.padding ??
//           const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(0)),
//       child: InkWell(
//         onTap: widget.callback,
//         child: SizedBox(
//           width: double.infinity,
//           // height: 300,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(height: 200,
//                 clipBehavior: Clip.antiAlias,
//                 decoration:
//                 BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: CachedNetworkImage(
//                   imageUrl: widget.store.flag,
//                   width: double.maxFinite,
//                   // height: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "${widget.store.name}",
//                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
//                             ),
//                             Text(
//                               "(${widget.store.currency} )",
//                               style: TextStyle(
//                                 // fontSize: 12,
//                                   color: Theme.of(context).primaryColor,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//
//                         // Row(
//                         //   children: [
//                         //
//                         //     Text(
//                         //       widget.store.currency,
//                         //       style: TextStyle(
//                         //         // fontSize: 12,
//                         //           color: Theme.of(context).primaryColor,
//                         //           fontWeight: FontWeight.bold),
//                         //     ),
//                         //   ],
//                         // ),
//                         // const SizedBox(
//                         //   height: 5,
//                         // ),
//                         // miniText(
//                         //   "${widget.store.description}",
//                         // ),
//                         // const SizedBox(
//                         //   height: 5,
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   roundedContainer(
//       IconData iconData, String text, void Function()? onTap, int number) {
//     return InkWell(
//       onTap: onTap,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             decoration: BoxDecoration(
//                 color: const Color(0xffF4F5F7),
//                 borderRadius: BorderRadius.circular(15)),
//             child: Row(
//               children: [
//                 Icon(
//                   iconData,
//                   size: 15,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   text,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//               right: -12,
//               top: 6,
//               child: CircleAvatar(
//                 radius: 12,
//                 backgroundColor: primarySwatch,
//                 child: Text(
//                   "${number}",
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }
//
// miniText(String text) {
//   return Text(
//     text,
//     style: const TextStyle(fontSize: 14),
//   );
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/json/country_model.dart';

class LanguageList extends StatelessWidget {
  final CountryModel chooseLanguages;
  bool isSelected;
  void Function()? onTap;
  LanguageList(
      {Key? key,
        required this.chooseLanguages,
        this.isSelected = false,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? CupertinoColors.activeGreen : null),
              child: ClipOval(
                child: Image.network(
                  chooseLanguages.flag,
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              chooseLanguages.name,
              style: TextStyle(
                  fontSize: 13, color: isSelected ? CupertinoColors.activeGreen : null),
            ),
            // Text(
            //   "(${chooseLanguages.currency})",
            //   style: TextStyle(
            //       fontSize: 9, color: isSelected ? Theme.of(context).primaryColor : null),
            // )
          ],
        ),
      ),
    );
  }
}

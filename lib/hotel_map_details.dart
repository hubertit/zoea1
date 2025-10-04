// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:tarama/json/venue.dart';
// import 'package:tarama/super_base.dart';
//
// import 'json/hotel.dart';
//
// class HotelMapDetails extends StatefulWidget{
//   final List<Venue>? list;
//   const HotelMapDetails({super.key, this.list});
//
//   @override
//   State<HotelMapDetails> createState() => _HotelMapDetailsState();
// }
//
// class _HotelMapDetailsState extends Superbase<HotelMapDetails> {
//   List<Venue> _list = [];
//   @override
//   void initState() {
//     _list = widget.list ?? _list;
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {loadData();});
//     setMarkers();
//     super.initState();
//   }
//
//   void loadData(){
//     ajax(
//     url: "hotels/",
//     method: "POST",
//     onValue: (obj, url) {
//       if (obj['venues'] is Iterable) {
//         _list = (obj['venues'] as Iterable)
//             .map((e) => Venue.fromJson(e))
//             .toList();
//         setState(setMarkers);
//       }
//     });
//   }
//
//   void setMarkers(){
//     _markers = _list.where((element) => element.venueRating != null).map((e) => Marker(markerId: MarkerId(unique),position: e.latLng!,infoWindow: InfoWindow(
//       title: e.name
//     ))).toList();
//     if(_list.isNotEmpty) {
//       _controller?.animateCamera(CameraUpdate.newLatLngZoom(_list.first.latLng!, 15.4746));
//     }
//   }
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(-1.9546312, 30.0904827),
//     zoom: 15.4746,
//   );
//
//   List<Marker> _markers = [];
//   GoogleMapController? _controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Maps"),
//         iconTheme: const IconThemeData(
//           color: Colors.black
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
//           color: Colors.black,
//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       body: GoogleMap(
//         mapType: MapType.terrain,
//         initialCameraPosition: _kGooglePlex,
//         markers: Set.of(_markers),
//         onMapCreated: (GoogleMapController controller) {
//           _controller = controller;
//         },
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:zoea1/json/location.dart';
import 'package:zoea1/json/place.dart';
import 'package:zoea1/partial/place_grid_item.dart';
import 'package:zoea1/super_base.dart';



class PlaceCollectionSearch extends StatefulWidget {
  final String query;
  const PlaceCollectionSearch({super.key,required this.query});

  @override
  State<PlaceCollectionSearch> createState() => _PlaceCollectionSearchState();
}

class _PlaceCollectionSearchState extends Superbase<PlaceCollectionSearch> {

  List<Place> _places = [];


  Future<void> loadData(){
    return ajax(url: "search/",method: "POST",data: FormData.fromMap({
      "query":widget.query
    }),onValue: (object,url){
      setState(() {
        _places = (object['data'] as Iterable?)?.map((e) => Place.fromJson(e)).toList() ?? [];
      });
    });
  }

  @override
  void didUpdateWidget(covariant PlaceCollectionSearch oldWidget) {
    if(oldWidget.query != widget.query){
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  final _focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus){
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20)
            .copyWith(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 15),
            //   child: Row(
            //     children: [
            //       Expanded(child: TextField(
            //         focusNode: _focusNode,
            //         decoration: const InputDecoration(
            //         hintText: "Date",
            //           suffixIcon: Icon(Icons.date_range)
            //       ),onTap: (){
            //         showDialog(context: context, builder:(context)=> Theme(
            //           data: Theme.of(context).copyWith(
            //               appBarTheme: ThemeData.fallback().appBarTheme,
            //           ),
            //           child: MediaQuery(
            //             data: MediaQuery.of(context).copyWith(
            //               size: Size(MediaQuery.of(context).size.width-50, MediaQuery.of(context).size.height-100)
            //             ),
            //             child: ClipRRect(
            //               clipBehavior: Clip.antiAliasWithSaveLayer,
            //               borderRadius: BorderRadius.circular(25),
            //               child: DateRangePickerDialog(currentDate: now,saveText: "Next",firstDate: now, lastDate: now.add(const Duration(
            //                   days: 360
            //               )),),
            //             ),
            //           ),
            //         ));
            //       },)),
            //       const SizedBox(width: 10,),
            //       Expanded(child: TextField(
            //         focusNode: _focusNode,
            //         onTap: (){
            //           showDialog(context: context, builder: (context)=>const LocationAlertDialog());
            //         },
            //         decoration: const InputDecoration(
            //           hintText: "Location",
            //           suffixIcon: Icon(Icons.location_on_sharp)
            //         ),
            //       )),
            //     ],
            //   ),
            // ),
            Expanded(
                child: GridView.builder(
              padding: const EdgeInsets.only(top: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.73),
              itemBuilder: (context, index) {
                return PlaceGridItem(place: _places[index]);
              },
              itemCount: _places.length,
            ))
          ],
        ),
      ),
    );
  }
}


class LocationAlertDialog extends StatefulWidget{
  const LocationAlertDialog({super.key});

  @override
  State<LocationAlertDialog> createState() => _LocationAlertDialogState();
}

class _LocationAlertDialogState extends State<LocationAlertDialog> {
  
  final _locations = [
    Location("Musanze", "Northern Province"),
    Location("Gisenyi", "Western Province"),
    Location("Akagera", "Western Province"),
    Location("ECO Park", "Western Province"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.close)),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text("Location",textAlign: TextAlign.center,style: Theme.of(context).appBarTheme.titleTextStyle,),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: TextField(
                        decoration: InputDecoration(
                        prefixIcon: Icon(Ionicons.search),
                          hintText: "Search Location"
                        ),
                      )),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 15)
                      ), child: const Text("Search"),)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: ListView.builder(itemBuilder: (context,index){
              var item = _locations[index];
              return ListTile(
                onTap: (){

                },
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                  child: const Icon(Icons.location_on_sharp),
                ),
                title: Text(item.name),
                subtitle: Text(item.province),
              );
            },itemCount: _locations.length,))
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context),style: TextButton.styleFrom(
          foregroundColor: Colors.red
        ), child: const Text("Cancel"),)
      ],
    );
  }
}

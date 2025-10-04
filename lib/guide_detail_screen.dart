import 'package:flutter/material.dart';

import 'json/guide.dart';
import 'constants/theme.dart';

class TourGuideDetailScreen extends StatefulWidget{
  final Guide guide;
  const TourGuideDetailScreen({super.key, required this.guide});

  @override
  State<TourGuideDetailScreen> createState() => _TourGuideDetailScreenState();
}

class _TourGuideDetailScreenState extends State<TourGuideDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kGrayLight
                ),
                height: 260,
              ),
              const SizedBox(height: 290,),
              Positioned(bottom: 0,left: 20,child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: kGrayLight,
                  ),
                  height: 120,
                  width: 120,
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.guide.names,style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontSize: 30
                ),),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("International tour guide in Musanze",style: TextStyle(
                    color: kGray
                  ),),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text("Travel and food vlogger",style: TextStyle(
                    color: kGray
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(child: ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
    textStyle: const TextStyle(
    fontWeight: FontWeight.w600
    )
                      ), child: const Text("Send Message"))),
                      const SizedBox(width: 10),
                      ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        backgroundColor: kGrayLight,
                        foregroundColor: kBlack,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 26),
                      ), child: const Text("Call Now")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Builder(
                    builder: (context) {
                      var style = const TextStyle(
                          color: kGray,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      );
                      var style1 = const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 17
                      );
                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Guide",textAlign: TextAlign.center,style: style,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("700+",textAlign: TextAlign.center,style: style1,),
                                ),
                              ],
                            )),
                             Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: VerticalDivider(color: kGrayDark,width: 0.5,),
                            ),
                            Expanded(flex: 2,child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Experience",textAlign: TextAlign.center,style: style,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("3 Years",textAlign: TextAlign.center,style: style1,),
                                ),
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: VerticalDivider(color: kGrayDark,width: 0.5,),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Rate",textAlign: TextAlign.center,style: style,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("3.0 /5",textAlign: TextAlign.center,style: style1,),
                                ),
                              ],
                            )),
                          ],
                        ),
                      );
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("About Us",style: Theme.of(context).appBarTheme.titleTextStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tortor ac leo lorem nisl. Viverra vulputate sodales quis et dui, lacus. Iaculis eu egestas leo egestas vel. Ultrices ut magna nulla facilisi commodo enim, orci feugiat pharetra. Id sagittis, ullamcorper turpis ultrices platea pharetra.",style: TextStyle(
                    color: kGray,
                    fontSize: 15
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Location",style: Theme.of(context).appBarTheme.titleTextStyle,),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  color: kGrayLight,
                  child: const SizedBox(
                    height: 150,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
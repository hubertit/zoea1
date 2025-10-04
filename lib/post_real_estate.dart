import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/phone_field.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/ults/style_utls.dart';

import '../../json/event_categories.dart';
import '../../json/place.dart';
import 'partial/adress_picker.dart';

class PostRealEstate extends StatefulWidget {
  const PostRealEstate({super.key});

  @override
  State<PostRealEstate> createState() => _PostRealEstateState();
}

class _PostRealEstateState extends Superbase<PostRealEstate> {
  DateTime? _eventDate;
  // DateTime? _checkOut;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final priceCotroller = TextEditingController();
  final roomsCotroller = TextEditingController();
  final bathsCotroller = TextEditingController();
  final parkingCotroller = TextEditingController();
  final offerTypeCotroller = TextEditingController();
  final propertyTypeCotroller = TextEditingController();

  var now = DateTime.now();
  List<String> offerTipe = ['Rent', "Sale"];
  List<String> propertyType = [
    'House',
    "Apartment",
    "Shared room",
    'Warehouse',
    'Land'
  ];
  List<String> furnished = ["Yes", "No"];
  String? selectedOffer;
  String? selectedPropertyType;
  String? selectedFurnished;
  late Country country;
  bool _loading = false;
  List<XFile>? _imageFiles = [];
  List<String> byteImages = [];

  List<EventCategory> _services = [];
  Future<void> loadCategories({bool fromHome = false}) {
    return ajax(
        url: "events/categories",
        method: "POST",
        onValue: (obj, url) {
          setState(() {
            _services = (obj['categories'] as Iterable?)
                    ?.map((e) => EventCategory.fromJson(e))
                    .toList() ??
                [];
            if (fromHome) {}
          });
        });
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      // Convert each image to base64
      byteImages = await Future.wait(pickedImages.map((image) async {
        return await imageToBase64(image);
      }));
      setState(() {
        _imageFiles = pickedImages;
      });
    }
  }

  Future<String> imageToBase64(XFile imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }
  //
  // Future<String> imageToBase64(XFile imageFile) async {
  //   List<int> imageBytes = await imageFile.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);
  //   print(base64Image);
  //   return base64Image;
  // }

  void postPropert() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      // await ajax(
      //     url: "housing/postProperty",
      //     method: "POST",
      //     data: FormData.fromMap({
      //       "token": User.user!.token,
      //       "location": locationCotroller.text,
      //       "price": priceCotroller.text,
      //       "property_type":
      //           selectedPropertyType, // Example values: "apartment", "house", "condo"
      //       "offer_type": selectedOffer, // Example values: "rent", "sale"
      //       "bedrooms": roomsCotroller.text,
      //       "bathrooms": bathsCotroller.text,
      //       "parking_size": parkingCotroller.text,
      //       "photos": byteImages
      //     }),
      //     onValue: (s, v) async {
      //       ScaffoldMessenger.of(context ?? this.context)
      //           .showSnackBar(const SnackBar(
      //               // backgroundColor: const Color(0xffb9cbcb),
      //               content: Text(
      //         "Property successfully posted and waiting to be reviewed",
      //         style: TextStyle(
      //             // color: Color(0xff10644D)
      //             ),
      //       )));
      //       if (s['code'] == 200) {
      //         showMessageSnack(s);
      //         goBack();
      //       } else {
      //         showMessageSnack(s);
      //         print(s);
      //       }
      //     });
      Future.delayed(const Duration(seconds: 1)).then((value) => goBack());
      ScaffoldMessenger.of(context ?? this.context).showSnackBar(const SnackBar(
          // backgroundColor: const Color(0xffb9cbcb),
          content: Text(
        "Thank you for submitting your property, we are reviewing your information and will get back to you shortly",
        style: TextStyle(
            // color: Color(0xff10644D)
            ),
      )),
      );
      setState(() {
        _loading = false;
      });
    } else {
      // If the form is not valid, you can display an error or simply wait
      print("Form is not valid");
    }
  }

  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Property"),
      ),
      body: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(platform: TargetPlatform.android),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: isDarkTheme(context) ? Colors.black : scaffoldColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15).copyWith(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: isDarkTheme(context) ? semiBlack : null,
                      //         borderRadius: BorderRadius.circular(5)),
                      //     child: TextFormField(
                      //       controller: locationCotroller,
                      //       validator: validateRequired,
                      //       decoration: InputDecoration(
                      //           contentPadding:
                      //               const EdgeInsets.symmetric(horizontal: 10),
                      //           border: StyleUtls.commonInputBorder,
                      //           hintText: 'Location'),
                      //       // )
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            // Open Google Map search here
                            String? selectedAddress = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressPickerScreen(),
                              ),
                            );

                            if (selectedAddress != null) {
                              locationController.text = selectedAddress; // Update the controller
                            }
                          },
                          child: AbsorbPointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkTheme(context) ? semiBlack : null,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: locationController,
                                validator: validateRequired,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  border: StyleUtls.commonInputBorder,
                                  hintText: 'Location',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: priceCotroller,
                            validator: validateRequired,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: StyleUtls.commonInputBorder,
                                hintText: 'Price in USD'),
                            // )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonFormField<String>(
                            hint: const Text("Property type"),
                            items: List.generate(
                                propertyType.length,
                                (index) => DropdownMenuItem(
                                    value: propertyType[index],
                                    child: Text("${propertyType[index]}"))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedPropertyType = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: StyleUtls.commonInputBorder,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonFormField<String>(
                            hint: Text("Offer type"),
                            items: List.generate(
                                offerTipe.length,
                                (index) => DropdownMenuItem(
                                    value: offerTipe[index],
                                    child: Text("${offerTipe[index]}"))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedOffer = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: StyleUtls.commonInputBorder,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: roomsCotroller,
                            validator: validateRequired,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: StyleUtls.commonInputBorder,
                                hintText: 'Number of bedrooms'),
                            // )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: bathsCotroller,
                            validator: validateRequired,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: StyleUtls.commonInputBorder,
                                hintText: 'Number of bathrooms'),
                            // )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context) ? semiBlack : null,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: parkingCotroller,
                            validator: validateRequired,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: StyleUtls.commonInputBorder,
                                hintText: 'Parking size (cars)'),
                            // )
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        hint: const Text("Is it furnished"),
                        items: List.generate(
                            furnished.length,
                            (index) => DropdownMenuItem(
                                value: furnished[index],
                                child: Text(furnished[index]))),
                        onChanged: (value) {
                          setState(() {
                            selectedFurnished = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: StyleUtls.commonInputBorder,
                          filled: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: _pickImages,
                        child: Container(
                          height: 150,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: isDarkTheme(context)
                                  ? semiBlack
                                  : const Color(0xfae4e4e4),
                              borderRadius: BorderRadius.circular(10)),
                          child: _imageFiles!.isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  children: _imageFiles!.map((file) {
                                    return Image.file(
                                      File(file.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  }).toList(),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Upload 10 Photos"),
                                      Center(
                                          child: Image.asset(
                                              "assets/gallery.png")),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: postPropert,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const Text(
                  "Post property",
                  style: TextStyle(color: Colors.white),
                )
        ),
      )),
    );
  }
}

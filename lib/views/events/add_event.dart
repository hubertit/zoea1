import 'dart:convert';
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/ults/style_utls.dart';
import '../../json/event_categories.dart';
import '../../partial/adress_picker.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends Superbase<CreateEventScreen> {
  DateTime? _eventDate;
  // DateTime? _checkOut;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final locationController = TextEditingController();
  final _ticketsUrlController = TextEditingController();
  final _descController = TextEditingController();

  bool _loading = false;
  // int? _size;
  XFile? _imageFile;
  String byteImage = '';
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     imageToBase64(pickedImage);
  //     setState(() {
  //       _imageFile = pickedImage;
  //     });
  //   }
  // }
  List<EventCategory> _services = [];
  String? selectedEventId;
  Future<void> loadCategories({bool fromHome = false}) {
    return ajax(
        url: "events/categories",
        method: "POST",
        onValue: (obj, url) {
          // print("Categories ${obj['categories']}");
          setState(() {
            // _services = (obj['categories'] as Iterable?)
            //         ?.map((e) => Service.fromJson(e))
            //         .toList() ??
            _services = (obj['categories'] as Iterable?)
                    ?.map((e) => EventCategory.fromJson(e))
                    .toList() ??
                [];
            if (fromHome) {
              // showCategoryModal();
            }
          });
        });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      String base64Image =
          await imageToBase64(pickedImage); // Convert image to base64
      setState(() {
        _imageFile = pickedImage;
        byteImage = base64Image; // Set byteImage after conversion
      });
    }
  }

  Future<String> imageToBase64(XFile imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    print(base64Image);
    return base64Image;
  }

  void postEvent() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "events/postEvent",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user!.token,
            "name": _eventNameController.text,
            "time": _eventDate,
            "address": locationController.text,
            "description": _descController.text,
            "poster": byteImage,
            "tickets_url": _ticketsUrlController.text,
            "category_id": selectedEventId
            // "name": _eventNameController.text,
            // "time": fmtDate(_checkIn, format: "yyyy-MM-dd"),
            // "address": _venueAddressController.text,
            // "description": _descController.text,
            // "event_poster": byteImage,
            // "tickets_url": _ticketsUrlController.text
          }),
          onValue: (s, v) async {
            if (s['code'] == 200) {
              showMessageSnack(s);

              goBack();
            } else {
              showMessageSnack(s);
              print(s);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post event"),
        ),
        body: Theme(
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
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: isDarkTheme(context) ? semiBlack : null,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              controller: _eventNameController,
                              validator: validateRequired,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  border: StyleUtls.commonInputBorder,
                                  hintText: 'Event name'),
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
                            child: DateTimeFormField(
                              validator: validateRequired,
                              mode: DateTimeFieldPickerMode.dateAndTime,
                              decoration: InputDecoration(
                                  hintText: "Date time",
                                  border: StyleUtls.commonInputBorder),
                              onChanged: (s) {
                                setState(() {
                                  _eventDate = s;
                                });
                              },
                              // initialDate: _eventDate,
                            ),
                          ),
                        ),
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
                              controller: _ticketsUrlController,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  border: StyleUtls.commonInputBorder,
                                  hintText: 'Tickets link'),
                              // )
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          validator: validateRequired,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkTheme(context) ? semiBlack : null,
                            border: StyleUtls.commonInputBorder,
                            hintText: "Select event category",
                          ),
                          items: _services
                              .map((service) => DropdownMenuItem(
                                  value: service,
                                  child: Text(service.categoryName)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedEventId = value!.categoryId;
                            });
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: isDarkTheme(context) ? semiBlack : null,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              minLines: 5,
                              maxLines: 7,
                              controller: _descController,
                              decoration: InputDecoration(
                                  hintText: "Description",
                                  border: StyleUtls.commonInputBorder),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              height: 150,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: isDarkTheme(context)
                                      ? semiBlack
                                      : const Color(0xfae4e4e4),
                                  borderRadius: BorderRadius.circular(10)),
                              child: _imageFile != null
                                  ? Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                      height: 200,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Event poster"),
                                          Center(
                                              child: Image.asset(
                                                  "assets/gallery.png")),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // _loading
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     : ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(5))),
                        //         onPressed: () {},
                        //         child: const Text(
                        //           "Post event",
                        //           style: TextStyle(color: Colors.white),
                        //         ))
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
                  onPressed:
                      // var json ={
                      //   "name":_eventNameController.text,
                      //   "time":_checkIn.toString(),
                      //   "address":_venueAddressController.text,
                      //   "description":_descController.text,
                      //   "poster":byteImage,
                      //   "tickets_url":_ticketsUrlController.text
                      // };
                      // print(json);
                      postEvent,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text(
                    "Post event",
                    style: TextStyle(color: Colors.white),
                  )),
        )),
      ),
    );
  }
}

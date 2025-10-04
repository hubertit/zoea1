import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zoea1/json/user.dart';
import 'package:zoea1/views/payments/sucess_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/apik.dart';
import '../../services/api_key_manager.dart';
import '../../json/package_model.dart';
import '../../partial/cover_container.dart';
import '../auth/widgets/auth_btn.dart';
import 'processing.dart';
import '../../constants/theme.dart';


class TransferMoneyScreen extends StatefulWidget {
  final String package;
  final String method;
  const TransferMoneyScreen(
      {super.key, required this.package, required this.method});

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  int userId = 0;
  @override
  void initState() {
    // TODO: implement initState
    // getUserId();
  }

  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // Future<void> getUserId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getInt('user_id')!;
  //   setState(() {});
  // }

  String returnAccount(String account) {
    if (account == "mtn") {
      return "MOMO";
    }
    return "Airtel money";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              children: [
                CoverContainer(children: [
                  (widget.method == "mtn" || widget.method == "airtel")
                      ? Text(
                          'Please  provide your ${returnAccount(widget.method)} account and pay your reservation',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      : const Text(
                          'You must provide you Phone number to continue'),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    cursorColor: Theme.of(context).brightness == Brightness.dark ? kWhite : kBlack,
                    // validator: ,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: const BorderSide(
                            color: Colors
                                .grey), // Set border color to grey when focused
                      ),
                      hintText: 'Enter your phone number',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),

                // Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : AuthButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var dynamicData = {
                                "user_id": User.user!.id,
                                "package_id": widget.package,
                                "method": widget.method,
                                "momo_number": phoneNumberController.text,
                              };
                              print('-----------------');
                              print(dynamicData);
                              print('-----------------');
                              if (widget.method == "visa" ||
                                  widget.method == "Master") {
                                sendData(dynamicData);
                              } else {
                                sendDynamicData(dynamicData);
                              }
                              // print(response.body);
                              // if (response.statusCode == 200) {
                              //   var jsonData = json.decode(response.body);
                              //   var status = jsonData['status'];
                              //   if (status == 'error') {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //         content: Text(jsonData['message']),
                              //       ),
                              //     );
                              //   } else if (status == 'Pending') {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 const ProcessingScreen()));
                              //   }
                              // }
                            }
                            // Example usage with dynamic data
                          },
                          text: widget.method == "mtn"
                              ? "Pay with MOMO"
                              : widget.method == "airtel"
                                  ? "Pay with Airtel money"
                                  : "Continue"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Optional: Add null check for momo_number

  Future<void> sendDynamicData(Map<String, dynamic> data) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('${baseUrll}payment/urubutoPay');
    var headers = {'Content-Type': 'application/json'};

    // Encode the dynamic data using convert.jsonEncode
    var body = convert.jsonEncode(data);

    var request = http.Request('POST', url);
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var streamData = await response.stream.bytesToString();
      print("__________");
      print(streamData);

      Map<String, dynamic> jsonData = json.decode(streamData);
      var status = jsonData['status'];
      if (status == 'error') {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
          ),
        );
      } else if (status == 'Pending') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    // ProcessingScreen(
                    //   data: jsonData['data'],
                    //   method: widget.method,
                    // )
              const SuccessScreen()
            ));
      }
    }else{print('');}
  }

  Future<void> sendData(var data) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('https://api.myapr.online/momo_pay');
    var headers = {'Content-Type': 'application/json'};

    // Encode the dynamic data using convert.jsonEncode
    var body = convert.jsonEncode(data);

    var request = http.Request('POST', url);
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var streamData = await response.stream.bytesToString();
      print("__________");
      print(streamData);

      Map<String, dynamic> jsonData = json.decode(streamData);
      var status = jsonData['status'];
      if (status == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
          ),
        );
      } else if (status == 'Pending') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProcessingScreen(
                      data: jsonData['data'],
                      method: widget.method,
                    )));
        launchUrl(Uri.parse(jsonData['data']['card_processing_url']));
        // print('==========');
        // print(jsonData['data']['card_processing_url']);
      }
    }
  }
}

import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/views/payments/sucess_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;

import '../../json/package_model.dart';
import 'processing.dart';
import 'transfer_screen.dart';
import 'widgets/summary_box.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String package;
  const PaymentMethodScreen({super.key, required this.package});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int userId = 0;
  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment method'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SummaryBox(
                          tape: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransferMoneyScreen(
                                          package: widget.package,
                                          method: "mtn",
                                        )));
                          },
                          image: AssetUtls.mtn,
                          title: 'MTN MOMO',
                          subtitle: const Text(
                            "MTN MOMO",
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                        width: 10,
                      ),
                      SummaryBox(
                          tape: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransferMoneyScreen(
                                          package: widget.package,
                                          method: "airtel",
                                        )));
                          },
                          image: AssetUtls.airtel,
                          title: '',
                          subtitle: const Row(
                            children: [
                              Text(
                                "Airtel Money",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
// const Text('Rwf')
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SummaryBox(
                          tape: () {
                            sendDynamicData('visa');
                          },
                          image: AssetUtls.visa,
                          title: '',
                          subtitle: const Text(
                            "Visa card",
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                        width: 10,
                      ),
                      SummaryBox(
                          tape: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>  TransferMoneyScreen(
                            //           package:  widget.package,method: "master",
                            //         )));
                            sendDynamicData('master');
                          },
                          image: AssetUtls.masterCArd,
                          title: '',
                          subtitle: const Row(
                            children: [
                              Text(
                                "Master card",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              // const Text('Rwf')
                            ],
                          )),
                    ],
                  ),
                ]),
              ));
  }

  Future<void> sendDynamicData(String method) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('https://tarama.ai/api/payment/urubutoPay');
    var headers = {'Content-Type': 'application/json'};
    var dynamicData = {
      "booking_id": widget.package,
      "method": method,
      "momo_number": '',
    };

    // Encode the dynamic data using convert.jsonEncode
    var body = convert.jsonEncode(dynamicData);

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
        launchUrl(Uri.parse(jsonData['data']['card_processing_url']));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
          ),
        );
        print(jsonData['data']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    // ProcessingScreen(
                    // data: jsonData['data'], method: method)
              const SuccessScreen()
            )
            );
      }
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:zoea1/homepage.dart';

import '../../partial/cover_container.dart';
import '../auth/widgets/auth_btn.dart';
import 'failed_screen.dart';
import 'sucess_screen.dart';


class ProcessingScreen extends StatefulWidget {
  final String method;
  final Map<String, dynamic> data;
  const ProcessingScreen({super.key, required this.data, required this.method});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController phoneContoller = TextEditingController();
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        checkStatus();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> checkStatus() async {
    try {
      var dynamicData = {"transaction_id": widget.data["transaction_id"]};
      var url = Uri.parse('https://api.myapr.online/check_status');
      var headers = {'Content-Type': 'application/json'};

      // Encode the dynamic data using convert.jsonEncode
      var body = convert.jsonEncode(dynamicData);

      var request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var streamData = await response.stream.bytesToString();
        print("__________");
        print(streamData);

        Map<String, dynamic> jsonData = json.decode(streamData);
        var status = jsonData['data']["transaction_status"];
        
        if (mounted) {
          if (status == 'FAILED') {
            _timer?.cancel();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const FailedScreen()));
          } else if (status == 'PENDING') {
            // Continue waiting
          } else if (status == "VALID") {
            _timer?.cancel();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()));
          }
        }
      } else {
        print('Payment status check failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking payment status: $e');
      // Don't cancel timer on error, let it retry
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Transaction ID is ${widget.data["transaction_id"]}");
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Processing'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              children: [
                 CoverContainer(children: [
                  Center(child: CircularProgressIndicator()),
                   if(widget.method == "mtn" || widget.method == "airtel") const SizedBox(
                    height: 30,
                  ),
                  if(widget.method == "mtn" || widget.method == "airtel")Text(
                      (widget.method == "mtn" || widget.method == "airtel")? 'Please dial *182*7# to confirm the payment':"",
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  const SizedBox(
                    height: 30,
                  ),
                ]),

                // Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: AuthButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const Homepage()));
                      },
                      text: "Cancel"),
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
}

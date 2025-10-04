import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  int _type = 1;
  String userPhone = '';
  String amount = '100';
  bool isLoading = false;

  final phoneRegExp = RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4}$');

  bool validatePhoneNumber(String phoneNumber) {
    return phoneRegExp.hasMatch(phoneNumber);
  }

  Future<void> requestPayment() async {
    setState(() {
      isLoading = true; // Show the loader
    });
    if(userPhone.isNotEmpty && validatePhoneNumber(userPhone)){
      final response = await http.post(
        Uri.parse('https://myapr.online/api/request-payment'),
        body: {
          'amount': amount,
          'mobilephone': userPhone
        },
        headers: {
          'Accept': 'application/json',
        },
      );

      //Check for server response
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          isLoading = false; // Show the loader
        });
        var jsonData = json.decode(response.body);
        var status = jsonData['status'];
        if(status == 'Pending'){
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonData['message']),
            ),
          );
        }
      }else{
        print(response.body);
        setState(() {
          isLoading = false; // Show the loader
        });

        // var jsonData = json.decode(response.body);
        // jsonData['errors'].forEach((key, value) {
        //   // Display the error message to the user.
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(value.toString()),
        //     ),
        //   );
        //   // print('Error: $key: $value');
        // });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Telephone number can be empty or Invalid"),
              ),
      );
    }
  }

  void _handleRadio(Object? e) => setState(() {
    _type = e as int;
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void> getUserPhone() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString('user_telephone')!;
      setState(() {});
    }

    getUserPhone();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true, // Center the title horizontally
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Payment methods",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0, // Adjust the font size as needed
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.orange.shade900),
        ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Show a loader
      ) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40,),
              Container(
                width: size.width,
                height: 65,
                decoration: BoxDecoration(
                  border: _type == 2 ? Border.all(width: 1, color: Colors.black) : Border.all(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: 2,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: const Color(0xFFDB3022),
                            ),
                            Text(
                              "Airtel Money",
                              style: _type == 2
                                  ? const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)
                                  : const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)
                            ),

                          ],
                        ),
                        Image.asset(
                          "assets/images/airtel-money.png",
                          width: 40,
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                width: size.width,
                height: 65,
                decoration: BoxDecoration(
                    border: _type == 1 ? Border.all(width: 1, color: Colors.black) : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _type,
                              onChanged: _handleRadio,
                              activeColor: const Color(0xFFDB3022),
                            ),
                            Text(
                                "MTN Momo",
                                style: _type == 1
                                    ? const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)
                                    : const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey)
                            ),

                          ],
                        ),
                        Image.asset(
                          "assets/images/momo.png",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                      ),
                  ),
                  const Text(
                    "100 RWF",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Trans-Fees",
              //       style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.w400,
              //           color: Colors.grey
              //       ),
              //     ),
              //     Text(
              //       "30 RWF",
              //       style: TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     )
              //   ],
              // ),
              // const Divider(
              //   color: Colors.black,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                    ),
                  ),
                  const Text(
                    "100 RWF",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: (){
                  requestPayment();
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text("Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

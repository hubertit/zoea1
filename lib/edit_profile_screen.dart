import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/choose_picuture_dialog.dart';
import 'package:zoea1/partial/custome_checkbox.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/style_utls.dart';
import 'package:zoea1/views/auth/widgets/auth_btn.dart';

import 'json/user.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends Superbase<EditProfileScreen> {

  String? _gender;
  final _key = GlobalKey<FormState>();
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _firstController.text = User.user?.fName ?? "";
    _lastController.text = User.user?.lName ?? "";
    _emailController.text = User.user?.email ?? "";
    _phoneController.text = User.user?.phone ?? "";
    _gender = User.user?.gender ?? "";
    _locationController.text = User.user?.location ?? "";
  }

  bool _saving = false;


  void updateProfile() async {
    if(_key.currentState?.validate()??false){
      setState(() {
        _saving = true;
      });
      await ajax(url: "account/updateProfile",method: "POST",data: FormData.fromMap(
          {
            "user_fname":_firstController.text,
            "user_lname":_lastController.text,
            "user_email":_emailController.text,
            "user_phone":_phoneController.text,
            "user_location":_locationController.text,
            "user_gender":_gender,
          }),onValue: (s,v){

        showSnack(s['message']);
        if(s['code'] == 200) {
          User.user?.phone = _phoneController.text;
          User.user?.email = _emailController.text;
          User.user?.fName = _firstController.text;
          User.user?.lName = _lastController.text;
          User.user?.location = _locationController.text;
          User.user?.gender = _gender;
          save(userKey, User.user?.toJson());
          goBack();
        }
      });
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          platform: TargetPlatform.android
        ),
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade500,
                      backgroundImage:
                      User.user?.profile != null ? CachedNetworkImageProvider(
                          User.user!.profile!) : null,
                    ),
                    Positioned(right: 0,bottom: 0,child: Material(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 4
                        )
                      ),
                      child: InkWell(
                        onTap: () async {
                         await showDialog(context: context, builder: (context)=>const ChoosePictureDialog());
                         setState(() {

                         });
                        },
                        child: const SizedBox(
                            height: 40,
                            width: 40,child: Icon(Icons.edit,color: Colors.white,size: 19,)),
                      ),
                    ))
                  ],
                ),
              ),

              // const Padding(
              //   padding: EdgeInsets.only(bottom: 10),
              //   child: Text("First Name",style: TextStyle(
              //     color: Color(0xff78828A),
              //     fontSize: 16
              //   ),),
              // ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _firstController,
                  validator: validateRequired,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: "Enter your first name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFB3B3B3)
                          : const Color(0xFF616161),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23242B)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColor
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(bottom: 10),
              //   child: Text("Last Name",style: TextStyle(
              //     color: Color(0xff78828A),
              //     fontSize: 16
              //   ),),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _lastController,
                  validator: validateRequired,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: "Enter your last name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFB3B3B3)
                          : const Color(0xFF616161),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23242B)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColor
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(bottom: 10),
              //   child: Text("E-mail",style: TextStyle(
              //     color: Color(0xff78828A),
              //     fontSize: 16
              //   ),),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFB3B3B3)
                          : const Color(0xFF616161),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23242B)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColor
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),

              DropdownButtonFormField<String>(
                value: null, // Initial value (null means no selection initially)
                onChanged: (String? newValue) {
                  // Update the selected gender here
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                validator: validateRequired, // Keep your validation logic
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: 'Gender',
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Male', 'Female', 'Other'] // Gender options
                    .map((String gender) => DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  validator: validateRequired,
                  controller: _locationController,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: "Location",
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFB3B3B3)
                          : const Color(0xFF616161),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23242B)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4D4D4D)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColor
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  minLines: 5,
                  maxLines: 7,
                ),
              ),
              _saving ? const Center(
                child: CircularProgressIndicator(),
              ) :
              // ElevatedButton(onPressed: updateProfile, child: const Text("Save Changes" ,)
              // )
              AuthButton(onPressed: updateProfile, text: "Save changes")
            ],
          ),
        ),
      ),
    );
  }
}
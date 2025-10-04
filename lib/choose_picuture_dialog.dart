
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoea1/super_base.dart';

import 'json/user.dart';
import 'constants/theme.dart';

class ChoosePictureDialog extends StatefulWidget{
  const ChoosePictureDialog({super.key});

  @override
  State<ChoosePictureDialog> createState() => _ChoosePictureDialogState();
}

class _ChoosePictureDialogState extends Superbase<ChoosePictureDialog> {

  
  
  bool _loading = false;
  
  void chooseImage({source = ImageSource.gallery})async{
    var xFile = await ImagePicker().pickImage(source: source);
    if(xFile != null){
      setState(() {
        _loading = true;
      });
      await ajax(url: "account/updateProfilePicture",method: "POST",data: FormData.fromMap(
          {
            "profile_picture":MultipartFile.fromFileSync(xFile.path)
          }),onValue: (obj,url){
        if(obj['code'] == 200){
          User.user?.profile = obj['farm_profile_picture'];
          save(userKey, User.user?.toJson());
          goBack(obj['farm_profile_picture']);
        }
      });

      setState(() {
        _loading = false;
      });
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change your Picture"),
      contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      content: _loading ? const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              color: kGrayLight,
              child: InkWell(
                onTap: ()=>chooseImage(source: ImageSource.camera),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text("Take a photo",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              color: kGrayLight,
              child: InkWell(
                onTap: chooseImage,
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.photo),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text("Choose from your file",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              color: kGrayLight,
              child: InkWell(
                onTap: (){},
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.delete,color: kGrayDark,),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text("Delete Photo",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: kGrayDark
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
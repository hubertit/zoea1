import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoea1/authentication.dart';
import 'package:url_launcher/url_launcher.dart';
import 'json/user.dart';
import 'main.dart';
import 'reg_ex_input_formatter.dart';
import 'stateful_builder_2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'services/api_key_manager.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

@optionalTypeArgs
abstract class Superbase<T extends StatefulWidget> extends State<T> {
  String get bigBase => "https://zoea.africa/api/"; // Will be updated dynamically
  final smallTextColor = const Color(0xff6f7680);

  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBjcGFpLnRlY2giLCJleHAiOjE2MDEyMTIzODF9.Lw8Acj_ldP4AakcucN3zKM7I1kTEqKTQc70VdfTga827oz1afKP9Gv54veYBVE0a4PEwN7jPt0xqefV_VsIMyg";

  String get server => bigBase;

  static String? smartKey;
  static String? gptKey;

  String userKey = "user-key-val";
  String tokenKey = "token-key-val";

  final formatter = NumberFormat.compact();

  static String? country;
  static String? tokenValue;

  Color appGrey = const Color(0xff2d2d37);

  EdgeInsets get listPadding => const EdgeInsets.all(30.0)
      .copyWith(top: MediaQuery.of(context).padding.top + 20);

  DateTime get utc => DateTime.now().toUtc();

  String get unique =>
      "${utc.millisecondsSinceEpoch}${const Uuid().v4().replaceAll("-", "")}";

  List<MaterialColor> get colors =>
      Colors.primaries.where((element) => element != Colors.yellow).toList();

  String url(String url) => "$server$url";

  Future<void> save(String key, dynamic val) {
    return saveVal(key, jsonEncode(val));
  }

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  RegExp emailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp disableSpecial = RegExp(r"[^.@a-zA-Z0-9]");
  RegExp phoneExp = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
  final amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  var platform = const MethodChannel('app.channel.shared.data');

  RegExp reg0 = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  Future<void> saveVal(String key, String value) async {
    (await prefs).setString(key, value);
    return Future.value();
  }

  String fmtDate(DateTime? date, {String format = "yyyy-MM-dd HH:mm:ss"}) {
    if (date == null) return "";

    return DateFormat(format).format(date);
  }

  void refresh(User? user) {
    setState(() {
      User.user = user;
    });
  }

  void openLink(String url) async {
    Uri? uri = Uri.tryParse(url);

    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<String> get getVersion async =>
      (await PackageInfo.fromPlatform()).version;

  bool get loggedOut => User.user == null;

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Phone number can not be empty";
    } else if (!regExp.hasMatch(value)) {
      return "Please input a valid phone number";
    } else {
      return null;
    }
  }

  String? validateName(String? value, {String name = ""}) {
    String pattern = r'^[a-zA-Z0-9_ \-=@,\.;]+$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "$name can not be empty";
    } else if (!regExp.hasMatch(value)) {
      return "Only alphabet A-Z and 0-9 allowed";
    } else {
      return null;
    }
  }

  Future<bool> get hasContactPermission async {
    if (await Permission.contacts.isGranted) {
      return true;
    } else if (PermissionStatus.granted ==
        await Permission.contacts.request()) {
      return true;
    } else {
      return false;
    }
  }

  void logOut() async {
    (await prefs).clear();
    User.user = null;
    push(const MyHomePage(title: "title"), replaceAll: true);
  }
  void authanticatePlease(){
    push(Authentication());
  }

  String? validateRequired(dynamic value) {
    const msg = "This field is required !!";
    if (value == null) {
      return msg;
    }

    if (value is String && value.trim().isEmpty) {
      return msg;
    }

    return null;
  }

  String? validateNonZero(dynamic value) {
    const msg = "This field is required!!";
    if (value == null) {
      return msg;
    }

    if(value is String && value.trim().isEmpty){
      return msg;
    }

    else if (value != null) {

      if (value == '0') return "Minimum is 1";
    }

    return null;
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty) {
      return "Email can not be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return "Enter a valid email.";
      }
      {
        final bool isValid = EmailValidator.validate(value);
        if (isValid) {
          return null;
        } else {
          return "Enter a valid email.";
        }
      }
    }
  }

  Widget errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const SizedBox.shrink();
  }

  String fmtDate2(DateTime? date) {
    if (date == null) return "";

    return DateFormat("yyyy-MM-dd").format(date);
  }

  String googleAPIKey = "AIzaSyAgU_8Z_hG2iWAL6K9QDdqdmes_YjFSK3s"; // Will be updated dynamically

  /// Update Google API Key dynamically
  Future<void> updateGoogleAPIKey() async {
    try {
      googleAPIKey = await ApiKeyManager.getGoogleAPIKey();
    } catch (e) {
      // Keep the fallback key if update fails
    }
  }

  /// Update Base URL dynamically
  Future<void> updateBaseUrl() async {
    try {
      final newBaseUrl = await ApiKeyManager.getApiBaseUrl();
      // Note: This would require a more complex implementation to update the getter
      // For now, we'll keep the current implementation
    } catch (e) {
      // Keep the fallback URL if update fails
    }
  }

  String fmt(String test) {
    return test.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  String fmtNbr(num? test) {
    if (test == null) {
      return "";
    }

    return fmt(test.toInt().toString());
  }

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<String> get localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<File> localFile(String name) async {
    final path = await localPath;
    return File('$path/$name');
  }

  Future<bool> confirmDialog(BuildContext context,
      {String title = "Confirm",
      String body = "Are you sure you want to logout?"}) async {
    bool? b = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("CANCEL")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("OK")),
            ],
          );
        });

    return b == true;
  }

  Widget loadBox(
      {Color? color,
      Color? bColor,
      double size = 20,
      double? value,
      double width = 3}) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        backgroundColor: bColor,
        strokeWidth: width,
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor),
      ),
    );
  }

  bool canDecode(String jsonString) {
    var decodeSucceeded = false;
    try {
      json.decode(jsonString);
      decodeSucceeded = true;
    } on FormatException catch (_) {}
    return decodeSucceeded;
  }

  Future<void> ajax(
      {required String url,
      String method = "GET",
      FormData? data,
      Map<String, dynamic>? map,
      Map<String, String>? headers,
      bool server = true,
      bool auth = true,
      bool local = false,
      bool base2 = false,
      String? authKey,
      bool json = true,
      void Function(CancelToken token)? onCancelToken,
      bool absolutePath = false,
      ResponseType responseType = ResponseType.json,
      bool localSave = false,
      String? jsonData,
      void Function(dynamic response, String url)? onValue,
      void Function()? onEnd,
      void Function(dynamic response, String url)? error}) async {

    // print("URL: $url");
    // print("Method: $method");
    // print("Data: ${data?.fields}");

    url = absolutePath ? url : this.url(url);

    headers = headers ?? <String, String>{};
    // headers['country'] = country ?? "";
    // headers["Accept"] = "application/json";

    var prf = await prefs;
    if (User.user?.token != null) {
      headers['Authorization'] = 'Bearer ${User.user!.token}';
      if (data != null) {
        data.fields.add(MapEntry("token", User.user!.token!));
        // print("FormData: ${data.fields}");
        // print(data.fields);
      } else {
        data = FormData.fromMap({"token": User.user!.token!});
        // print(data.fields);
      }
    }

    Options opt = Options(
        responseType: responseType,
        headers: headers,
        contentType: ContentType.json.value,
        receiveDataWhenStatusError: true,
        sendTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000));

    if (!server) {
      String? val = prf.getString(url);
      bool t = onValue != null && val != null;
      local = local && t;
      localSave = localSave && t;
      var c = (t && json && canDecode(val)) || !json;
      t = t && c;
      if (t) onValue(json ? jsonDecode(val) : val, url);
    }

    if (local) {
      if (onEnd != null) onEnd();
      return Future.value();
    }

    CancelToken token = CancelToken();

    if (onCancelToken != null) {
      onCancelToken(token);
    }

    Future<Response> future = method.toUpperCase() == "POST"
        ? Dio().post(url,
            data: jsonData ?? map ?? data, options: opt, cancelToken: token)
        : method.toUpperCase() == "PUT"
            ? Dio().put(url,
                data: jsonData ?? map ?? data, options: opt, cancelToken: token)
            : method.toUpperCase() == "DELETE"
                ? Dio().delete(url,
                    data: jsonData ?? map ?? data,
                    options: opt,
                    cancelToken: token)
                : Dio().get(url, options: opt, cancelToken: token);

    try {
      Response response = await future;
      dynamic data = response.data;

      if (response.statusCode == 401) {
        if (onEnd != null) onEnd();
        showSnack("Login First");
        return Future.value();
      } else if (response.statusCode == 200) {
        //var cond = (data is String && json && canDecode(data)) || !json;
        if (!server && ((data is String && canDecode(data)) || data is Map)) {
          saveVal(url, jsonEncode(data));
        }

        if (data is Map && data.containsKey("code") && data['code'] == 403) {
          // logOut();
          return Future.value();
        }

        if (onValue != null && !localSave) {
          if (data is Map && data.containsKey("code") && data['code'] != 200) {
            showMessageSnack(data);
          } else {
            onValue(data, url);
          }
        } else {
          showMessageSnack(data);
          if (error != null) {
            error(data, url);
          }
        }
      } else {
        showMessageSnack(data);
        if (error != null) {
          error(data, url);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // showMessageSnack("Request timed out. Please try again.");
      }else{
      //if (e.response != null) {
      var resp = e.response != null ? e.response!.data : e.message;
      if (!absolutePath) {
        // showMessageSnack(e.message);
        // showMessageSnack("Poor internet connection");
      }
      if (error != null) {
        error(resp, url);
      }

      if (e.response?.statusCode == 401 && User.user != null) {
        if (onEnd != null) onEnd();
        showSnack("Login First");
        logOut();
        return Future.value();
      }
      //}
    }
    }

    if (onEnd != null) onEnd();
    return Future.value();
  }

  Widget frameBuilder(
      BuildContext context, Widget child, int? frame, bool was) {
    return frame == null
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          )
        : child;
  }

  final _key = GlobalKey<StatefulBuilderState2>();

  void closeMd() {
    _key.currentState?.pop();
  }

  Future<void> showMd({BuildContext? context}) async {
    //Timer(Duration(seconds: 8), ()=>this.canPop());
    await showGeneralDialog(
        transitionDuration: const Duration(seconds: 1),
        barrierDismissible: false,
        context: context ?? this.context,
        barrierColor: Colors.black12,
        pageBuilder: (context, _, __) {
          return StatefulBuilder2(
              key: _key,
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  content: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(7)),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Loading...",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });

    return Future.value();
  }

  Future<G?> push<G>(Widget widget,
      {BuildContext? context,
      bool replace = false,
      bool replaceAll = false,
      bool fullscreenDialog = false,
      bool replaceAllExceptOne = false}) async {
    var pageRoute = CupertinoPageRoute<G>(
        builder: (context) => widget, fullscreenDialog: fullscreenDialog);

    context = context ?? this.context;
    var navigatorState = Navigator.of(context);

    if (replace) {
      return await navigatorState.pushReplacement(pageRoute);
    } else {
      if (replaceAll) {
        navigatorState.popUntil((route) => route.isFirst);
        return await navigatorState.pushReplacement(pageRoute);
      }

      if (replaceAllExceptOne) {
        // navigatorState.popUntil((route) => route.isFirst);
        return await navigatorState.pushAndRemoveUntil(
            pageRoute, (route) => route.isFirst);
      }

      return await navigatorState.push<G>(pageRoute);
    }
  }

  void goBack([data]) {
    Navigator.pop(context, data);
  }

  void showMessageSnack(object) {
    if (object is Map && object.containsKey("message")) {
      showSnack(object['message']);
    } else if (object is String) {
      showSnack(object);
    } else if (object != null) {
      showSnack(object.toString());
    } else {
      showSnack("Something went wrong !");
    }
  }

  void showSnack(String text, {BuildContext? context}) {
    ScaffoldMessenger.of(context ?? this.context).showSnackBar(SnackBar(
        // backgroundColor: const Color(0xffb9cbcb),
        content: Text(
      text,
      style: const TextStyle(
          // color: Color(0xff10644D)
          ),
    )));
  }

  String get defAddress => "default-address-key";
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

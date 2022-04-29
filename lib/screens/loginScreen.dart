import 'dart:convert';
import 'package:flutter/services.dart';
import '../ui/ui_helper.dart';
import 'package:samcopayslip/utls/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'package:device_information/device_information.dart';
//import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hiddentText = true;
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Future<void> checkPermissions(BuildContext context) async {
  //   Map<Permission, PermissionState> permission =
  //       await PermissionsPlugin.checkPermissions([Permission.READ_PHONE_STATE]);
  //   if (permission[Permission.READ_PHONE_STATE] != PermissionState.GRANTED) {
  //     try {
  //       permission = await PermissionsPlugin.requestPermissions(
  //           [Permission.READ_PHONE_STATE]);
  //     } on Exception {
  //       debugPrint("Error");
  //     }
  //     if (permission[Permission.READ_PHONE_STATE] == PermissionState.GRANTED)
  //       // print("Login ok");
  //       initPlatformState();
  //   } else {
  //     initPlatformState();
  //     print("Login ok");
  //   }
  // }
/*
  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: const Text("Permisos denegados"),
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: const Text(
                  "Debes conceder todo los permiso para poder usar esta aplicacion",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }
*/
  Future<void> initPlatformState() async {
    String platformVersion, imeiNo = '', modelName = '', manufacturer = '';

    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }
    if (!mounted) return;
    logger.d(platformVersion);
    logger.d(imeiNo);
    logger.d(modelName);
    logger.d(manufacturer);
    setState(() {
      _platformVersion = platformVersion;
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
    });
  }

  void _toggleVisibility() {
    setState(() {
      hiddentText = !hiddentText;
    });
  }

  Widget get _logo => Center(
        child: Container(
          height: 80,
          width: 80,
          child: CircleAvatar(
            backgroundColor: UIHelper.TRANPARENT,
            child: new Image.asset(
              'assets/icon/icon.png',
              height: 80.0,
              fit: BoxFit.cover,
            ),

            //  Text(
            //   "Logo",
            //   style:
            //       TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
            // ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance.init(context);
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: UIHelper.WHITE,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomPaint(
              painter: CurvePainter(),
              child: Container(
                height: UIHelper.dynamicHeight(250.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: <Widget>[
                  _logo,

                  TextFormField(
                      controller: userController,
                      keyboardType: TextInputType.phone,
                      autocorrect: true,
                      obscureText: false,
                      style:
                          TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.login,
                              color: UIHelper.CHERRY_PRIMARY_COLOR),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "เลขบัตรพนักงาน",
                          hintStyle: TextStyle(color: UIHelper.MUZ_TEXT_COLOR),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.trim().isEmpty) return "กรอก User";
                      }),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      obscureText: hiddentText,
                      style:
                          TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key,
                              color: UIHelper.CHERRY_PRIMARY_COLOR),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: IconButton(
                              icon: hiddentText
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: _toggleVisibility,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: UIHelper.password,
                          hintStyle: TextStyle(color: UIHelper.MUZ_TEXT_COLOR),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.trim().isEmpty) return "Password";
                      }),
                  _loginButton,
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: new ForgetPasswordButton(
                  //     color: UIHelper.CHERRY_PRIMARY_COLOR,
                  //     rightPadding: 0,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _loginButton => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: MaterialButton(
          height: 56,
          minWidth: double.infinity,
          color: UIHelper.CHERRY_PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30)),
          onPressed: () async {
            if ((userController.text == "") ||
                (passwordController.text == "")) {
              Toast.show("จำเป็น ต้องกรอก User Password ", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            } else {
              var url = Uri.parse(serveurl + '/pays/userlogin');
              var response = await http.post(url, body: {
                "user": userController.text,
                "password": passwordController.text,
              });
              await Future<void>.delayed(Duration(seconds: 1));
              //  print(response);
              if (response.statusCode == 200) {
                var _extractdata = json.decode(response.body);
                var listdata = _extractdata["datarow"];
                if (listdata == 0) {
                  Toast.show("User หรือ Password ไม่ถูกต้อง", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                } else {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool result = await prefs.setString(
                      'sysProfile', jsonEncode(listdata[0]));
                  prefs.setInt('getcross', 1);
                  if (result == true) {
                    if (_imeiNo != '') {
                      var url = Uri.parse(serveurl + '/pays/setuserDevice');
                      var rese = await http.post(url, body: {
                        'user': userController.text,
                        'imeiNo': _imeiNo,
                        'modelName': _modelName,
                        'manufacturerName': _manufacturerName,
                        'platform': _platformVersion,
                      });
                      if (rese.statusCode == 200) {
                        //var _extractdata = json.decode(rese.body);
                        // var ls = _extractdata["results"];
                        // logger.d(ls);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (Route<dynamic> route) => false);
                      }
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (Route<dynamic> route) => false);
                    }
                  }
                }
              } else {
                Toast.show("User หรือ Password ไม่ถูกต้อง", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                // print('Request failed with status: ${response.statusCode}.');
              }
            }
          },
          child: Text(
            UIHelper.login.toUpperCase(),
            style: TextStyle(
                fontSize: UIHelper.dynamicSp(60),
                color: UIHelper.WHITE,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
          ),
        ),
      );
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()..color = UIHelper.CHERRY_PRIMARY_COLOR;
    // create a path
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.300,
        size.width * 0.5, size.height * 0.760);
    path.quadraticBezierTo(size.width * 0.75, size.height * 1.3, size.width * 1,
        size.height * 0.940);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samcopayslip/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utls/const.dart';
import '../ui/ui_helper.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'loginScreen.dart';

class PasswordScreen extends StatefulWidget {
  PasswordScreen({Key key, this.profi}) : super(key: key);
  final Profile profi;
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController oldpassController = TextEditingController();
  TextEditingController retrypassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hiddentText = true;
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
      appBar: AppBar(
        title: Text("เปลี่ยนรหัสเข้าใช้งาน"),
        actions: [
          //IconButton(icon: Icon(Icons.flash_on), onPressed: () => {}),
          // IconButton(icon: Icon(Icons.grid_on), onPressed: () => {crossOper()}),
        ],
        elevation: 5.0,
        backgroundColor: UIHelper.CHERRY_PRIMARY_COLOR,
      ),
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
                      controller: oldpassController,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      obscureText: false,
                      style:
                          TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key_sharp,
                              color: UIHelper.STRAWBERRY_SHADOW),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: UIHelper.oldpassword,
                          hintStyle: TextStyle(color: UIHelper.MUZ_TEXT_COLOR),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.trim().isEmpty)
                          return UIHelper.passwordRequired;
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
                              color: UIHelper.APRICOT_PRIMARY_COLOR),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: UIHelper.newpassword,
                          hintStyle: TextStyle(color: UIHelper.MUZ_TEXT_COLOR),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.trim().isEmpty)
                          return UIHelper.passwordRequired;
                      }),
                  TextFormField(
                      controller: retrypassController,
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
                          labelText: UIHelper.retrypassword,
                          hintStyle: TextStyle(color: UIHelper.MUZ_TEXT_COLOR),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.trim().isEmpty)
                          return UIHelper.passwordRequired;
                      }),
                  _loginButton,
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
            if ((oldpassController.text == "") ||
                (passwordController.text == "") ||
                (retrypassController.text == "")) {
              Toast.show("ตรวจสอบข้อมูล !!!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            } else if (passwordController.text != retrypassController.text) {
              Toast.show("Password ต้องเหมือนกัน !!!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            } else {
              // print(widget.profi.sSID);
              //  print(widget.profi.code);
              // print(passwordController.text);
              //  print(oldpassController.text);
              //  print(widget.profi.password);

              var url = Uri.parse(serveurl + '/pays/dropOffchangepassword');

              var response = await http.post(url, body: {
                'code': widget.profi.code,
                'oldPass': oldpassController.text,
                'curentHash': widget.profi.password,
                'password': passwordController.text,
              });
              if (response.statusCode == 200) {
                var _extractdata = json.decode(response.body);
                var status = _extractdata["status"];
                if (status == '1') {
                  Toast.show(_extractdata["detail"], context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool result = await prefs.clear();
                  if (result == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  }
                } else {
                  Toast.show(_extractdata["detail"], context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
              } else {
                // print('Request failed with status: ${response.statusCode}.');
              }
              // await http
              //     .post(serveurl + '/pays/dropOffchangepassword', headers: {
              //   "Accept": "application/json"
              // }, body: {
              //   'code': widget.profi.code,
              //   'oldPass': oldpassController.text,
              //   'curentHash': widget.profi.password,
              //   'password': passwordController.text,
              // }).then((res) async {
              //   var _extractdata = json.decode(res.body);
              //   //  print(_extractdata);
              //   var status = _extractdata["status"];
              //   if (status == '1') {
              //     Toast.show(_extractdata["detail"], context,
              //         duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              //     SharedPreferences prefs =
              //         await SharedPreferences.getInstance();
              //     bool result = await prefs.clear();
              //     if (result == true) {
              //       Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => LoginScreen(),
              //           ),
              //           (Route<dynamic> route) => false);
              //     }
              //   } else {
              //     Toast.show(_extractdata["detail"], context,
              //         duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              //   }
              // });
            }
          },
          child: Text(
            // UIHelper.login.toUpperCase(),
            UIHelper.changepassword.toUpperCase(),
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

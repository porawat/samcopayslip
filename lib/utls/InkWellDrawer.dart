import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart'; //mobile
import 'package:samcopayslip/model/profile.dart';
import 'package:samcopayslip/screens/CreatePdf50tv.dart';
import 'package:samcopayslip/screens/historygrid.dart';
import 'package:samcopayslip/screens/loginScreen.dart';
import 'package:samcopayslip/screens/password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();

class InkWellDrawer extends StatefulWidget {
  @override
  _InkWellDrawerState createState() => _InkWellDrawerState();
}

class _InkWellDrawerState extends State<InkWellDrawer> {
  String profileName = 'สมชาย';
  Profile profile = new Profile();
  String version = '';
  String buildno = '';
  PackageInfo pinfo;
  initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map valueMap = json.decode(prefs.getString('sysProfile'));
    print("Version is: ${info.version}");
    setState(() {
      profile = new Profile.fromJson(valueMap);
      profileName = profile.thaiName;
      version = info.version;
      buildno = info.buildNumber;
      pinfo = info;
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    // if (profile.thaiName == "") {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else {
    return new Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 60, 0, 1.0),
          // gradient: LinearGradient(colors: <Color>[
          //   Color.fromRGBO(0, 50, 0, 1.0),
          //   // Color.fromRGBO(0, 60, 0, 1.0),
          //   // Color.fromRGBO(0, 70, 0, 1.0)
          // ])
        ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
                child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    // elevation: 0.5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icon/icon.png",
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    profileName,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )
                ],
              ),
            )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white10),
              ),
            ),
            Expanded(
              child: Column(children: <Widget>[
                ListTile(
                  title: Text(
                    '50 ทวิ',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.filter_5,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => CreatePdf50Tv()));
                  },
                ),

                // ListTile(
                //   title: Text(
                //     'ข้อมูลย้อนหลัง',
                //     style: TextStyle(fontSize: 18.0, color: Colors.white),
                //   ),
                //   leading: Image.asset(
                //     'assets/images/history.png',
                //     height: 20.0,
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.of(context).push(new MaterialPageRoute(
                //         builder: (context) => HistoryPaySlipScreen()));
                //   },
                // ),
                ListTile(
                  title: Text(
                    'ข้อมูลย้อนหลัง',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: Image.asset(
                    'assets/images/history.png',
                    height: 20.0,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => Historygrid()));
                  },
                ),
                ListTile(
                  title: Text(
                    'เปลี่ยน Password',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  // leading: Icon(
                  //   Icons.vpn_key,
                  //   size: 20.0,
                  //   color: Colors.white,
                  // ),
                  leading: Image.asset(
                    'assets/images/key.png',
                    height: 20.0,
                  ),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new PasswordScreen(profi: profile)))
                  },
                ),
                ListTile(
                  title: Text(
                    'ออกจากระบบ',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: Image.asset(
                    'assets/images/power.png',
                    height: 20.0,
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('sysProfile').then((value) => {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (Route<dynamic> route) => false)
                        });
                    // bool result = await prefs.clear();

                    // if (result == true) {

                    // }
                  },
                )
              ]),
            ),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Divider(),
                        // ListTile(
                        //     leading: Icon(Icons.settings),
                        //     title: Text('Facebook')),
                        ListTile(
                            onTap: () {
                              // logger.d(pinfo.packageName);
                            },
                            leading: Icon(
                              Icons.help,
                              color: Colors.white,
                            ),
                            title: Text('v$version b$buildno',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white)))
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
            splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(icon, color: color),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Text(
                          text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.green[900],
                    )
                  ],
                ))),
      ),
    );
  }
}

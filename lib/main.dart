import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:samcopayslip/ui/ui_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'utls/splash_screen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
  logger.d("hello ios!");
}

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  String connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    /*
    requestPermissions().then((value) {
      if (value == true) {
        //checkPermissions();
        autoLogIn();
      }
    });
    */
    autoLogIn();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

/*
  Future<void> checkPermissions() async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.checkPermissions([Permission.READ_PHONE_STATE]);
    if (permission[Permission.READ_PHONE_STATE] != PermissionState.GRANTED) {
      try {
        permission = await PermissionsPlugin.requestPermissions(
            [Permission.READ_PHONE_STATE]);
      } on Exception {
        debugPrint("Error");
      }
    }
  }
*/
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // case ConnectivityResult.none:
        setState(() => connectionStatus = result.toString());
        break;
      default:
        setState(() => connectionStatus = 'Failed_connectivity');
        break;
    }
    //print("status " + connectionStatus);
  }

/*
  Future<bool> requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
    return permission == PermissionStatus.granted;
  }
*/
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String profile = prefs.getString('sysProfile') ?? "";
    if (profile != "") {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return gotoApp();
  }

  Widget gotoApp() {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        // supportedLocales: [
        //   Locale('en'),
        //   Locale("th"),
        // ],
        title: 'สลิปเงินเดือน',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home:
            //
            //Splash(),
            connectionStatus == 'Failed_connectivity'
                ? ErrororConnection()
                : Splash() // PDFCreator(),
        );
  }
}

class ErrororConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 76, 76, 76),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 76, 76, 76),
          title: const Text('สลิปเงินเดือน'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _logo,
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              ),
              Center(
                  child: Text("กรุณาเชื่อมต่อ Internet ",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 248, 247, 246))))
            ]));
  }

  Widget get _logo => Center(
        child: Container(
          height: 80,
          width: 80,
          child: CircleAvatar(
            backgroundColor: UIHelper.TRANPARENT,
            child: new Image.asset(
              'assets/images/attention.png',
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
}

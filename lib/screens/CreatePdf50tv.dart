import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
//import 'package:logger/logger.dart';
import 'package:samcopayslip/model/profile.dart';
import 'package:samcopayslip/utls/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:toast/toast.dart';
// ignore: unused_import
import '../mobile.dart' if (dart.library.html) '../web.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
//var logger = Logger();

class CreatePdf50Tv extends StatefulWidget {
  const CreatePdf50Tv({Key key}) : super(key: key);

  @override
  State<CreatePdf50Tv> createState() => _CreatePdf50TvState();
}

class _CreatePdf50TvState extends State<CreatePdf50Tv> {
  DateTime selectedDate;
  Profile profile = new Profile();
  Year50tv item50tv;
  List<Year50tv> historyData = [];
  // int newyear;
  String path = '';
  final PathProviderPlatform provider = PathProviderPlatform.instance;
  Future<String> _appDocumentsDirectory;
  @override
  initState() {
    super.initState();
    _requestAppDocumentsDirectory();
    getData();
  }

  void _requestAppDocumentsDirectory() {
    _appDocumentsDirectory = provider.getApplicationDocumentsPath();
    _appDocumentsDirectory.then((value) {
      //logger.d(value);
      setState(() {
        path = value;
      });
    });
  }

  void showToast(String msg) {
    Toast.show(msg, context, duration: 2, gravity: Toast.CENTER);
  }

  getData() async {
    //  logger.d("getData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map valueMap = json.decode(prefs.getString('sysProfile'));
    setState(() {
      profile = new Profile.fromJson(valueMap);
    });
    // logger.d(profile.code);
    // logger.d(seleDate.year.toString());
    var url = Uri.parse(serveurl + '/pays/mobile50tv');
    // var p50tv = seleDate.year - 1;
    var response = await http
        .post(url, body: {'empCode': profile.code}).timeout(
            Duration(seconds: 60), onTimeout: () {
      throw TimeoutException('The connection has timed out, Please try again!');
    });
    if (response.statusCode == 200) {
      var _extractdata = json.decode(response.body);
      // logger.d(_extractdata);
      if (_extractdata["results"] == "success") {
        // var listdata = _extractdata["rows"]; //ข้อมูลเดียว
        var t50tvlist = _extractdata["rows"] as List;
        List<Year50tv> tagObjs =
            t50tvlist.map((tagJson) => Year50tv.fromJson(tagJson)).toList();
        // Map objdata = listdata[0]; //map  data

        setState(() {
          //  item50tv = new Year50tv.fromJson(objdata); //set state
          historyData = tagObjs;
        });
        //logger.d(item50tv.address);
      } else {
        showToast("ไม่มีข้อมูล");
      }
    } else {
      showToast("เกิดข้อผิดพลาดกรุณาลองใหม่");
      //logger.e("no data");
    }
  }

  Widget _listItem(index) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () => generateInvoice(historyData[index]),
        leading: Text(historyData[index].taxYear,
            style: const TextStyle(fontSize: 18)),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            Text(
                historyData[index].payTotal.replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},'),
                style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 14, 12, 14))), // icon-1
            Icon(Icons.picture_as_pdf_outlined,
                color: Color.fromARGB(255, 248, 2, 2)), // icon-2
          ],
        ),
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
    );
  }

  Future<void> _pullRefresh() async {
    await getData();
    // logger.d("refresh");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('หนังสือหักภาษี ณ ที่จ่าย(50ทวิ)'),
        ),
        body: historyData == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: new Text("ไม่มีข้อมูล",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.black)),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(2),
                      color: Color.fromARGB(255, 218, 218, 216),
                      child: const ListTile(
                        leading: Text('  ปี',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 23, 1, 130))),
                        // title: Text('เดือน',
                        //     style: const TextStyle(
                        //         fontSize: 20,
                        //         color: Color.fromARGB(255, 23, 1, 130))),
                        trailing: Text('รายได้',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 23, 1, 130))),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: historyData.length,
                          itemBuilder: (_, index) {
                            return _listItem(index);
                          }),
                    ),
                    // Center(
                    //   child: new Text("ข้อมูลปี " + item50tv.taxYear,
                    //       style:
                    //           new TextStyle(fontSize: 18.0, color: Colors.black)),
                    // ),
                    //SizedBox(height: 20.0),
                    // Center(
                    //   child: Ink(
                    //       decoration: const ShapeDecoration(
                    //         color: Colors.lightGreen,
                    //         shape: CircleBorder(),
                    //       ),
                    //       child: IconButton(
                    //           icon: Image.asset(
                    //             'assets/images/pdffile.png',
                    //             height: 50.0,
                    //           ),
                    //           color: Colors.red[900],
                    //           onPressed: null)),
                    // ),
                  ],
                )));
  }

  Future<void> generateInvoice(Year50tv itemtv) async {
    // PdfFont font = PdfTrueTypeFont(await _readFontCorDia(), 15);
    // PdfFont font2 = PdfTrueTypeFont(await _readFontCorDia(), 14);
    //PdfFont fontcordia = PdfTrueTypeFont(await _readFontCorDia(), 14);
    PdfFont fontcordia12 = PdfTrueTypeFont(await _readFontCorDia(), 12);
    // PdfStringFormat alrigth = PdfStringFormat(
    //   textDirection: PdfTextDirection.leftToRight,
    //   alignment: PdfTextAlignment.right,
    // );
    PdfStringFormat alcenter = PdfStringFormat(
      textDirection: PdfTextDirection.leftToRight,
      alignment: PdfTextAlignment.center,
    );
    PdfStringFormat alleft = PdfStringFormat(
      textDirection: PdfTextDirection.leftToRight,
      alignment: PdfTextAlignment.left,
    );
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('50TWI01A.pdf'));
    final page = document.pages[0].layers.add(name: 'Layer1', visible: true);
    PdfGraphics graphics = page.graphics;

    graphics.drawString(itemtv.empID, fontcordia12,
        bounds: const Rect.fromLTWH(71, 211.5, 50, 30));
    // dept
    graphics.drawString(itemtv.dept, fontcordia12,
        brush: PdfSolidBrush(PdfColor(0, 0, 24)),
        bounds: const Rect.fromLTWH(150, 211.5, 50, 30));
    // name
    graphics.drawString(itemtv.fName + ' ' + itemtv.lName, fontcordia12,
        brush: PdfSolidBrush(PdfColor(0, 0, 24)),
        bounds: const Rect.fromLTWH(47, 230, 100, 30));
    //ที่อยู่
    graphics.drawString(itemtv.address, fontcordia12,
        bounds: const Rect.fromLTWH(47, 247, 200, 100));
//บัตรประชาชน
    graphics.drawString(itemtv.cardID, fontcordia12,
        bounds: const Rect.fromLTWH(130, 277, 100, 30));
//เลขประจำตัวผู้เสียถาษี
    /* 
    graphics.drawString(
        item50tv.taxID == null ? item50tv.cardID : item50tv.taxID, fontcordia12,
        bounds: const Rect.fromLTWH(125, 281, 100, 30));
*/
    //เงินสมทบ
    graphics.drawString(itemtv.pFYTD, fontcordia12,
        bounds: const Rect.fromLTWH(110, 377, 100, 30));
    //เลขประกันสังคม
    graphics.drawString(itemtv.cardID, fontcordia12,
        bounds: const Rect.fromLTWH(47, 425, 200, 30));
// ลำดับที่
    graphics.drawString(itemtv.item, fontcordia12,
        bounds: const Rect.fromLTWH(75, 445, 50, 30));

//อื่นๆ
    graphics.drawString(
        itemtv.reason == null ? '' : itemtv.reason, fontcordia12,
        bounds: const Rect.fromLTWH(360, 376, 250, 30));
    //จ่าย2 16
    graphics.drawString(itemtv.pay2, fontcordia12,
        bounds: const Rect.fromLTWH(666, 377, 55, 30), format: alcenter);
    //หักนำส่ง 2 17
    graphics.drawString(itemtv.tax2, fontcordia12,
        bounds: const Rect.fromLTWH(745, 377, 65, 30), format: alcenter);
    //จ่าย 18
    graphics.drawString(itemtv.payTotal, fontcordia12,
        bounds: const Rect.fromLTWH(666, 394, 55, 30), format: alcenter);

    //หักนำส่ง 2 19
    graphics.drawString(itemtv.taxTotal, fontcordia12,
        bounds: const Rect.fromLTWH(745, 394, 65, 30), format: alcenter);

    //ตัวอักษร 20
    graphics.drawString(itemtv.bahtText, fontcordia12,
        bounds: const Rect.fromLTWH(548, 411, 250, 30), format: alleft);
    //PF 21
    graphics.drawString(itemtv.proFund, fontcordia12,
        bounds: const Rect.fromLTWH(655, 428.5, 80, 30), format: alcenter);
    //date
    var year = int.parse(itemtv.taxYear) + 1;
    graphics.drawString("15 / 01 / " + year.toString(), fontcordia12,
        bounds: const Rect.fromLTWH(645, 478, 80, 30), format: alcenter);
    //ลำดับที่ item 1
    graphics.drawString(itemtv.item, fontcordia12,
        bounds: const Rect.fromLTWH(770, 62, 40, 50), format: alcenter);
    //ปีที่จ่าย 12
    graphics.drawString(itemtv.taxYear, fontcordia12,
        bounds: const Rect.fromLTWH(605, 94, 50, 30), format: alcenter);
    //หักนำส่ง1 14
    //จ่าย1 13
    graphics.drawString(itemtv.pay1, fontcordia12,
        bounds: const Rect.fromLTWH(665, 94, 55, 30), format: alcenter);
    //หักนำส่ง1 14
    graphics.drawString(itemtv.tax1, fontcordia12,
        bounds: const Rect.fromLTWH(740, 94, 65, 30), format: alcenter);
    List<int> bytes = document.save();
    document.dispose();
    // var pdname = 'payslip${selectedDate.month}-${selectedDate.year}.pdf';
    //var pdname = 'payslip50Tv.pdf';
    //saveAndLaunchFile(bytes, pdname);
    var pdname = 'payslip50${itemtv.taxYear}.pdf';
//Create an empty file to write PDF data
    File file = File('$path/' + pdname); //ios

//Write PDF data
    await file.writeAsBytes(bytes, flush: true); //ios

    // var pdname = 'payslip${selectedDate.month}-${selectedDate.year}.pdf';
    OpenFile.open('$path/' + pdname); //ios
  }
}

Future<List<int>> _readDocumentData(String name) async {
  final ByteData data = await rootBundle.load('assets/pdf/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<List<int>> _readFontCorDia() async {
  final ByteData bytes = await rootBundle.load('assets/fonts/cordia.ttf');
  return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:samcopayslip/model/payslip.dart';
import 'package:samcopayslip/model/profile.dart';
import 'package:samcopayslip/utls/const.dart';
import 'package:samcopayslip/utls/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:toast/toast.dart';
// ignore: unused_import
import '../mobile.dart' if (dart.library.html) '../web.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:open_file/open_file.dart';

var logger = Logger();

class Historygrid extends StatefulWidget {
  @override
  _HistorygridState createState() => _HistorygridState();
}

class _HistorygridState extends State<Historygrid> {
  // HDTRefreshController _hdtRefreshController = HDTRefreshController();
  final PathProviderPlatform provider = PathProviderPlatform.instance;
  Profile profile = new Profile();
  List<HistoryDataList> historyData = [];
  Future<String> _appDocumentsDirectory;
  static const int sortName = 0;
  bool isAscending = true;
  int sortType = sortName;
  DateTime selectedDate;
  String path = '';
  Payslipinfo slipinfo;
  double expr1,
      expr2,
      expr3,
      expr4,
      expr5,
      expr6,
      expr7,
      expr8,
      expr9,
      expr10,
      expr11,
      expr6s;
  String expr1s,
      expr2s,
      expr3s,
      expr4s,
      expr5s,
      expr7s,
      expr8s,
      expr9s,
      expr10s,
      expr11s;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  @override
  void initState() {
    super.initState();
    _requestAppDocumentsDirectory();
    getData();
  }

  void _requestAppDocumentsDirectory() {
    _appDocumentsDirectory = provider.getApplicationDocumentsPath();
    _appDocumentsDirectory.then((value) {
      // logger.d(value);
      setState(() {
        path = value;
      });
    });
  }

  void showToast(String msg) {
    Toast.show(msg, context, duration: 2, gravity: Toast.CENTER);
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map valueMap = json.decode(prefs.getString('sysProfile'));
    setState(() {
      profile = new Profile.fromJson(valueMap);
      // print(profile.code);
    });
    try {
      var url = Uri.parse(serveurl + '/pays/historygrid');
      var response = await http.post(url, body: {'code': profile.code}).timeout(
          Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      //print(response);
      if (response.statusCode == 200) {
        var _extractdata = json.decode(response.body);
        // print(_extractdata);
        if (_extractdata["results"] == "success") {
          var listdata = _extractdata["rows"] as List;
          List<HistoryDataList> tagObjs = listdata
              .map((tagJson) => HistoryDataList.fromJson(tagJson))
              .toList();
          setState(() {
            historyData = tagObjs;
          });
        } else {
          //print('error');
          showToast("ไม่มีข้อมูล");
          setState(() {
            // canclick = false;
          });
        }
      } else if (response.statusCode == 503) {
        // canclick = false;
        showToast("ไม่มีข้อมูล");
      } else {
        // print('Request failed with status: ${response.statusCode}.');
      }
    } on TimeoutException catch (e) {
      print(e);
      showToast("ไม่สามารถติดต่อ Server ได้!!!");
    }
  }

  getOldData(
    String code,
    String month,
    String year,
    String dateoff,
  ) async {
    // print(code);
    // print(month);
    // print(year);
    // print(dateoff);
    var url = Uri.parse(serveurl + '/pays/mobileoffgrid');
    var response = await http.post(url,
        body: {'code': profile.code, 'DateOff': dateoff, 'year': year});
    if (response.statusCode == 200) {
      var _extractdata = json.decode(response.body);
      if (_extractdata["results"] == "success") {
        var listdata = _extractdata["datarow"];
        // print(json.decode(listdata[0]).runtimeType);
        Map objdata = listdata[0];
        setState(() {
          slipinfo = new Payslipinfo.fromJson(objdata);
          expr1 = double.tryParse(slipinfo.extra1).abs() +
              double.tryParse(slipinfo.extra2).abs();
          expr2 = double.tryParse(slipinfo.backPay).abs() +
              double.tryParse(slipinfo.incOther1).abs() +
              double.tryParse(slipinfo.incOther2).abs();
          expr3 = double.tryParse(slipinfo.oT2).abs() +
              double.tryParse(slipinfo.oTDF).abs() +
              double.tryParse(slipinfo.oTHD).abs();
          expr4 = double.tryParse(slipinfo.oT15).abs() +
              double.tryParse(slipinfo.oT15S).abs();
          expr5 = double.tryParse(slipinfo.wageOther).abs() +
              double.tryParse(slipinfo.lawComp).abs();
          expr6 = double.tryParse(slipinfo.tax).abs() +
              double.tryParse(slipinfo.taxN).abs() +
              double.tryParse(slipinfo.compenTax).abs();
          expr7 = double.tryParse(slipinfo.coop2SCB).abs() +
              double.tryParse(slipinfo.coop2SAMCO).abs() +
              double.tryParse(slipinfo.coopDebtAdd).abs();
          expr8 = double.tryParse(slipinfo.insurance).abs() +
              double.tryParse(slipinfo.insuranceDeves).abs();
          expr9 = double.tryParse(slipinfo.returnWage).abs() +
              double.tryParse(slipinfo.returnReward).abs();
          expr10 = double.tryParse(slipinfo.other4).abs() +
              double.tryParse(slipinfo.crem).abs();
          expr11 = double.tryParse(slipinfo.coop1SAMCO).abs() +
              double.tryParse(slipinfo.appCoopSAMCO).abs();
          expr1s = expr1.toStringAsFixed(2);
          expr2s = expr2.toStringAsFixed(2);
          expr3s = expr3.toStringAsFixed(2);
          expr4s = expr4.toStringAsFixed(2);
          expr5s = expr5.toStringAsFixed(2);
          expr6s = expr6;
          expr7s = expr7.toStringAsFixed(2);
          expr8s = expr8.toStringAsFixed(2);
          expr9s = expr9.toStringAsFixed(2);
          expr10s = expr10.toStringAsFixed(2);
          expr11s = expr11.toStringAsFixed(2);
        });
        await _createPDF();
      } else {
        showToast("ไม่มีข้อมูล");
        setState(() {
          this.slipinfo = null;
        });
      }
    } else if (response.statusCode == 503) {
      showToast("ไม่มีข้อมูล");
      this.slipinfo = null;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  _createPDF() async {
    PdfFont font = PdfTrueTypeFont(await _readFontCorDia(), 15);
    PdfFont font2 = PdfTrueTypeFont(await _readFontCorDia(), 14);
    PdfFont fontcordia = PdfTrueTypeFont(await _readFontCorDia(), 16);
    String newssid = Utils.setformat(slipinfo.sSID);
    String bankAc = Utils.setformatbankAcc(slipinfo.bankAccount);
    PdfStringFormat alrigth = PdfStringFormat(
      textDirection: PdfTextDirection.leftToRight,
      alignment: PdfTextAlignment.right,
    );
    PdfStringFormat alcenter = PdfStringFormat(
      textDirection: PdfTextDirection.leftToRight,
      alignment: PdfTextAlignment.center,
    );
    /*
    PdfStringFormat alleft = PdfStringFormat(
      textDirection: PdfTextDirection.leftToRight,
      alignment: PdfTextAlignment.left,
    );
*/
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('PaySlip_Template_Cordia2.pdf'));
    final page = document.pages[0].layers.add(name: 'Layer1', visible: true);
    PdfGraphics graphics = page.graphics;
    graphics.drawString(
        slipinfo.depart == null
            ? ""
            : "พ้นสภาพ " + Utils.newPayDate(slipinfo.depart),
        fontcordia,
        bounds: const Rect.fromLTWH(460, 80, 200, 50));
    graphics.drawString(slipinfo.thaiName, fontcordia,
        bounds: const Rect.fromLTWH(100, 109, 200, 50));
    graphics.drawString(slipinfo.code, font,
        bounds: const Rect.fromLTWH(470, 109, 200, 50));
    graphics.drawString(slipinfo.orgCode, fontcordia,
        bounds: const Rect.fromLTWH(112, 134, 200, 50));
    graphics.drawString(slipinfo.orgName, fontcordia,
        bounds: const Rect.fromLTWH(143, 134, 500, 50));
    graphics.drawString(newssid, fontcordia,
        bounds: const Rect.fromLTWH(196, 160, 200, 50));
    graphics.drawString(Utils.newPayDate(slipinfo.payDate), font,
        bounds: const Rect.fromLTWH(424, 161, 200, 50));
    graphics.drawString(slipinfo.workPlace, fontcordia,
        bounds: const Rect.fromLTWH(118, 186, 500, 50));
    graphics.drawString(
        slipinfo.salary == "0" ||
                slipinfo.salary == "0.00" ||
                slipinfo.salary == ""
            ? ""
            : double.tryParse(slipinfo.salary)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 266, 60, 30),
        format: alrigth);
    //ค่าจ้างอื่นๆ
    graphics.drawString(
        expr5 == 0.00
            ? ""
            : double.tryParse(expr5s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 286, 60, 30),
        format: alrigth);
//ค่าจ้างปกติ
    graphics.drawString(
        slipinfo.wage == "0" || slipinfo.wage == "0.00" || slipinfo.wage == ""
            ? ""
            : slipinfo.noDays,
        font2,
        bounds: const Rect.fromLTWH(96, 307, 200, 50));
    graphics.drawString(
        slipinfo.wage == "0" || slipinfo.wage == "0.00" || slipinfo.wage == ""
            ? ""
            : double.tryParse(slipinfo.wage)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 307, 60, 30),
        format: alrigth);
//ค่าล่วงเวลา 1 เท่า
    graphics.drawString(
        slipinfo.oT1 == "0" || slipinfo.oT1 == "0.00" || slipinfo.oT1 == ""
            ? ""
            : double.tryParse(slipinfo.oT1)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 328, 60, 30),
        format: alrigth);
//ค่าล่วงเวลา 1.5 เท่า
    graphics.drawString(
        expr4 == 0.00
            ? ""
            : double.tryParse(expr4s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 350, 60, 30),
        format: alrigth);
    //ค่าล่วงเวลา 2 เท่า
    graphics.drawString(
        expr3 == 0.00
            ? ""
            : double.tryParse(expr3s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 370, 60, 30),
        format: alrigth);
    //ค่าล่วงเวลา 3 เท่า
    graphics.drawString(
        slipinfo.oT3 == "0" || slipinfo.oT3 == "0.00" || slipinfo.oT3 == ""
            ? ""
            : double.tryParse(slipinfo.oT3)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 392, 60, 30),
        format: alrigth);
//เงินรางวัล
    graphics.drawString(
        slipinfo.reward == "0" ||
                slipinfo.reward == "0.00" ||
                slipinfo.reward == ""
            ? ""
            : double.tryParse(slipinfo.reward)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 413, 60, 30),
        format: alrigth);

    //เบี้ยบริหารงาน
    graphics.drawString(
        slipinfo.cola == "0" || slipinfo.cola == "0.00" || slipinfo.cola == ""
            ? ""
            : double.tryParse(slipinfo.cola)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 434, 60, 30),
        format: alrigth);
    //gเงินเพิ่มพิเศษ
    graphics.drawString(
        expr1 == 0.00
            ? ""
            : double.tryParse(expr1s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 455, 60, 30),
        format: alrigth);
    //เบี้ยเลี้ยงปฎิบัต
    graphics.drawString(
        slipinfo.allowance == "0" ||
                slipinfo.allowance == "0.00" ||
                slipinfo.allowance == ""
            ? ""
            : double.tryParse(slipinfo.allowance)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 475, 60, 30),
        format: alrigth);
    //เบี้ยเลี้ยงนอกเวลา
    graphics.drawString(
        slipinfo.outtime == "0" ||
                slipinfo.outtime == "0.00" ||
                slipinfo.outtime == ""
            ? ""
            : double.tryParse(slipinfo.outtime)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 497.5, 60, 30),
        format: alrigth);
    //เบี้ยขยัน
    graphics.drawString(
        slipinfo.diligent == "0" ||
                slipinfo.diligent == "0.00" ||
                slipinfo.diligent == ""
            ? ""
            : double.tryParse(slipinfo.diligent)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 517, 60, 30),
        format: alrigth);
    //ค่าเสียง
    graphics.drawString(
        slipinfo.risk == "0" || slipinfo.risk == "0.00" || slipinfo.risk == ""
            ? ""
            : double.tryParse(slipinfo.risk)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 539.5, 60, 30),
        format: alrigth);
    //ค่าตากแดด
    graphics.drawString(
        slipinfo.sUN == "0" || slipinfo.sUN == "0.00" || slipinfo.sUN == ""
            ? ""
            : double.tryParse(slipinfo.sUN)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 560, 60, 30),
        format: alrigth);

    //ค่าสวัสดิการ
    graphics.drawString(
        slipinfo.welfare == "0" ||
                slipinfo.welfare == "0.00" ||
                slipinfo.welfare == ""
            ? ""
            : double.tryParse(slipinfo.welfare)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 582.5, 60, 30),
        format: alrigth);
    //เงินได้อื่นๆ
    graphics.drawString(
        expr2 == 0.00
            ? ""
            : double.tryParse(expr2s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 603, 60, 30),
        format: alrigth);
    //เงินได้อื่นๆรับแล้ว
    graphics.drawString(
        slipinfo.incOther3 == "0" ||
                slipinfo.incOther3 == "0.00" ||
                slipinfo.incOther3 == ""
            ? ""
            : double.tryParse(slipinfo.incOther3)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(135, 623, 60, 30),
        format: alrigth);

//รายการหัก
// ณที่จ่าย

    graphics.drawString(
        expr6 == 0.00
            ? ""
            : double.tryParse(expr6s.abs().toString())
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 267.5, 60, 30),
        format: alrigth);
// เงินยืมทดลอง
    graphics.drawString(
        slipinfo.advance == "0" ||
                slipinfo.advance == "0.00" ||
                slipinfo.advance == ""
            ? ""
            : double.tryParse(slipinfo.advance)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 267.5, 60, 30),
        format: alrigth);

// สำรอง
    graphics.drawString(
        slipinfo.empPF == "0" ||
                slipinfo.empPF == "0.00" ||
                slipinfo.empPF == ""
            ? ""
            : double.tryParse(slipinfo.empPF)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 287.5, 60, 30),
        format: alrigth);
// เบี้ยประกัน
    graphics.drawString(
        expr8 == 0.00
            ? ""
            : double.tryParse(expr8s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 287.5, 60, 30),
        format: alrigth);

    // ประกันสังคม
    graphics.drawString(
        slipinfo.empSS == "0" ||
                slipinfo.empSS == "0.00" ||
                slipinfo.empSS == ""
            ? ""
            : double.tryParse(slipinfo.empSS)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 308, 60, 30),
        format: alrigth);
    // เงินบริจาค
    graphics.drawString(
        slipinfo.donate == "0" ||
                slipinfo.donate == "0.00" ||
                slipinfo.donate == ""
            ? ""
            : double.tryParse(slipinfo.donate)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 308, 60, 30),
        format: alrigth);

    // บำรุงฌาปนกิจ
    graphics.drawString(
        slipinfo.appCrem == "0" ||
                slipinfo.appCrem == "0.00" ||
                slipinfo.appCrem == ""
            ? ""
            : double.tryParse(slipinfo.appCrem)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 328, 60, 30),
        format: alrigth);
    // ค่าความเสียหาย
    graphics.drawString(
        slipinfo.damageFee == "0" ||
                slipinfo.damageFee == "0.00" ||
                slipinfo.damageFee == ""
            ? ""
            : double.tryParse(slipinfo.damageFee)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 329.5, 60, 30),
        format: alrigth);

    // ฌาปนกิจ
    graphics.drawString(
        slipinfo.cremSAMCO == "0" ||
                slipinfo.cremSAMCO == "0.00" ||
                slipinfo.cremSAMCO == ""
            ? ""
            : double.tryParse(slipinfo.cremSAMCO)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 347.5, 60, 30),
        format: alrigth);
    // [บังคับคดี]
    graphics.drawString(
        slipinfo.legalDpt == "0" ||
                slipinfo.legalDpt == "0.00" ||
                slipinfo.legalDpt == ""
            ? ""
            : double.tryParse(slipinfo.legalDpt)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 350, 60, 30),
        format: alrigth);

// บำรุงฌาปนกิจ scb
    graphics.drawString(
        expr10 == 0.00
            ? ""
            : double.tryParse(expr10s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 367, 60, 30),
        format: alrigth);
// เงินเดือนเรียกคืน
    graphics.drawString(
        expr9 == 0.00
            ? ""
            : double.tryParse(expr9s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 369, 60, 30),
        format: alrigth);

    // ฝากสหกรณ์ samco
    graphics.drawString(
        slipinfo.coopSamco == "0" ||
                slipinfo.coopSamco == "0.00" ||
                slipinfo.coopSamco == ""
            ? ""
            : double.tryParse(slipinfo.coopSamco)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 389.5, 60, 30),
        format: alrigth);
    // ฝากสหกรณ์ samco
    graphics.drawString(
        slipinfo.telephone == "0" ||
                slipinfo.telephone == "0.00" ||
                slipinfo.telephone == ""
            ? ""
            : double.tryParse(slipinfo.telephone)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 392.5, 60, 30),
        format: alrigth);

    // ค่าหุ้นสหกรณ์ samco
    graphics.drawString(
        expr11 == 0.00
            ? ""
            : double.tryParse(expr11s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 412, 60, 30),
        format: alrigth);
    // ค่าบัตร
    graphics.drawString(
        slipinfo.card == "0" || slipinfo.card == "0.00" || slipinfo.card == ""
            ? ""
            : double.tryParse(slipinfo.card)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 415, 60, 30),
        format: alrigth);

// ค่าหุ้นสหกรณ์ scb
    var coop1SCBh = double.parse(slipinfo.coop1SCB).abs();
    graphics.drawString(
        slipinfo.coop1SCB == "0" ||
                slipinfo.coop1SCB == "0.00" ||
                slipinfo.coop1SCB == ""
            ? ""
            : double.tryParse(coop1SCBh.toString())
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 434, 60, 30),
        format: alrigth);
// กยศ
    graphics.drawString(
        slipinfo.sLF == "0" || slipinfo.sLF == "0" || slipinfo.sLF == ""
            ? ""
            : double.tryParse(slipinfo.sLF)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 434.5, 60, 30),
        format: alrigth);

// เงินกู้ สหกรณ์
    graphics.drawString(
        expr7 == 0.00
            ? ""
            : double.tryParse(expr7s)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(316, 456, 60, 30),
        format: alrigth);
// อื่นๆ 1
    graphics.drawString(
        slipinfo.salaryDeduc == "0" ||
                slipinfo.salaryDeduc == "0.00" ||
                slipinfo.salaryDeduc == ""
            ? ""
            : double.tryParse(slipinfo.salaryDeduc)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 455, 60, 30),
        format: alrigth);
// อื่นๆ 2
    var trainingh = double.parse(slipinfo.training).abs();
    graphics.drawString(
        slipinfo.training == "0" ||
                slipinfo.training == "0.00" ||
                slipinfo.training == ""
            ? ""
            : double.tryParse(trainingh.toString())
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 476, 60, 30),
        format: alrigth);
// อื่นๆ 3
    graphics.drawString(
        slipinfo.other3 == "0" ||
                slipinfo.other3 == "0.00" ||
                slipinfo.other3 == ""
            ? ""
            : double.tryParse(slipinfo.other3)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 498, 60, 30),
        format: alrigth);
// อื่นๆ 4
    graphics.drawString(
        slipinfo.form == "0" || slipinfo.form == "0.00" || slipinfo.form == ""
            ? ""
            : double.tryParse(slipinfo.form)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 519.5, 60, 30),
        format: alrigth);
    // อื่นๆ รับ
    graphics.drawString(
        slipinfo.incOther3 == "0" ||
                slipinfo.incOther3 == "0.00" ||
                slipinfo.incOther3 == ""
            ? ""
            : double.tryParse(slipinfo.incOther3)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(500, 541, 60, 30),
        format: alrigth);

// เงินได้สะสม
    graphics.drawString(
        slipinfo.incomeYTD == "0" ||
                slipinfo.incomeYTD == "0.00" ||
                slipinfo.incomeYTD == ""
            ? ""
            : double.tryParse(slipinfo.incomeYTD)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(80, 701, 100, 30),
        format: alrigth);
// ภาษีสะสม
    graphics.drawString(
        slipinfo.taxYTD == "0" ||
                slipinfo.taxYTD == "0.00" ||
                slipinfo.taxYTD == ""
            ? ""
            : double.tryParse(slipinfo.taxYTD)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(80, 724, 100, 30),
        format: alrigth);

// ประกันสังคมสะสม
    graphics.drawString(
        slipinfo.sSYTD == "0" ||
                slipinfo.sSYTD == "0.00" ||
                slipinfo.sSYTD == ""
            ? ""
            : double.tryParse(slipinfo.sSYTD)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(265, 701, 100, 30),
        format: alrigth);
// กองทุนสำรองสะสม
    graphics.drawString(
        slipinfo.pFYTD == "0" ||
                slipinfo.pFYTD == "0.00" ||
                slipinfo.pFYTD == ""
            ? ""
            : double.tryParse(slipinfo.pFYTD)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font2,
        bounds: const Rect.fromLTWH(265, 724, 100, 30),
        format: alrigth);

// [[สถานะภาพ]]
    graphics.drawString(slipinfo.taxPayType, font2,
        bounds: const Rect.fromLTWH(360, 681, 200, 30), format: alrigth);
// [บุตร 1]
    graphics.drawString(
        slipinfo.childNotEdu == "0" ? "" : slipinfo.childNotEdu, font2,
        bounds: const Rect.fromLTWH(510, 702, 50, 30), format: alrigth);
// [บุตร 2]
    graphics.drawString(
        slipinfo.childEdu == "0" ? "" : slipinfo.childEdu, font2,
        bounds: const Rect.fromLTWH(510, 726, 50, 30), format: alrigth);
// รวมเงินได้ประจำเดือน
    graphics.drawString(
        slipinfo.totalInc == "0" ||
                slipinfo.totalInc == "0.00" ||
                slipinfo.totalInc == ""
            ? ""
            : double.tryParse(slipinfo.totalInc)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font,
        bounds: const Rect.fromLTWH(40, 786, 120, 30),
        format: alcenter);
// รวมเงินหักประจำเดือน
    graphics.drawString(
        slipinfo.totalDed == "0" ||
                slipinfo.totalDed == "0.00" ||
                slipinfo.totalDed == ""
            ? ""
            : double.tryParse(slipinfo.totalDed)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font,
        bounds: const Rect.fromLTWH(180, 786, 120, 30),
        format: alcenter);
// เงินได้สุทธิ
    graphics.drawString(
        slipinfo.netIncome == "0" ||
                slipinfo.netIncome == "0.00" ||
                slipinfo.netIncome == ""
            ? ""
            : double.tryParse(slipinfo.netIncome)
                .toStringAsFixed(2)
                .replaceAllMapped(reg, mathFunc),
        font,
        bounds: const Rect.fromLTWH(320, 786, 120, 30),
        format: alcenter);
// การรับ
    graphics.drawString(
        slipinfo.bankAccount == "9999999999" ? "" : bankAc, font,
        bounds: const Rect.fromLTWH(448, 786, 120, 30), format: alcenter);
    List<int> bytes = document.save();
    document.dispose();

    // final directory = await getExternalStorageDirectory(); //ios

//Get directory path
    //final path = directory.path; //ios
    var pdname = 'payslip${slipinfo.offmonth}-${slipinfo.offyear}.pdf';
    // logger.d(pdname);
    File file = File('$path/' + pdname);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/' + pdname);
//Create an empty file to write PDF data
    //  File file = File('$path/' + pdname); //ios

//Write PDF data
    //  await file.writeAsBytes(bytes, flush: true); //ios

    // var pdname = 'payslip${selectedDate.month}-${selectedDate.year}.pdf';
    //OpenFile.open('$path/' + pdname); //ios
    //saveAndLaunchFile(bytes, pdname); //android
    // saveAndLaunchFile(bytes, pdname); //web
  }

  Widget _listItem(index) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          getOldData(historyData[index].code, historyData[index].offmonth,
              historyData[index].offyear, historyData[index].dateOff);
        },
        leading: Text(historyData[index].offyear,
            style: const TextStyle(fontSize: 18)),
        title: Text(
          historyData[index].offmonthName,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            Text(
                historyData[index].netIncome.replaceAllMapped(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการรับเงินเดือน'),
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                color: Color.fromARGB(255, 218, 218, 216),
                child: const ListTile(
                  leading: Text('  ปี',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 23, 1, 130))),
                  title: Text('  เดือน',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 23, 1, 130))),
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
            ],
          )),
    );
  }
}

Future<List<int>> _readDocumentData(String name) async {
  final ByteData data = await rootBundle.load('assets/pdf/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

/*
Future<List<int>> _readFontData() async {
  final ByteData bytes = await rootBundle.load('assets/fonts/angsa.ttf');
  return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
}
*/
Future<List<int>> _readFontCorDia() async {
  final ByteData bytes = await rootBundle.load('assets/fonts/cordia.ttf');
  return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
}

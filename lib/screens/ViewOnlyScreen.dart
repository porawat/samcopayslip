import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:samcopayslip/model/payslip.dart';
import 'package:samcopayslip/model/profile.dart';
import 'package:samcopayslip/ui/ui_helper.dart';
import 'package:samcopayslip/utls/const.dart';
import 'package:samcopayslip/utls/utils.dart';
import 'loginScreen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ViewOnly extends StatefulWidget {
  final Profile profile;
  const ViewOnly({Key key, this.profile}) : super(key: key);
  @override
  _ViewOnlyState createState() => _ViewOnlyState();
}

class _ViewOnlyState extends State<ViewOnly> {
  Payslipinfo slipinfo;
  initState() {
    super.initState();
    // print(widget.profile.thaiName);
    gatData();
  }

  gatData() async {
    var month = {'value': '4', 'viewValue': 'เมษายน', 'inis': 'เม.ย.'};

    var url = Uri.parse(serveurl + '/pays/mobiledropoff');

    var response = await http.post(url, body: {
      'month': json.encode(month),
      'year': '2021',
    });
    if (response.statusCode == 200) {
      var _extractdata = json.decode(response.body);
      if (_extractdata["results"] == "success") {
        var listdata = _extractdata["datarow"];
        // print(json.decode(listdata[0]).runtimeType);
        //typeof
        Map objdata = listdata[0];
        setState(() {
          slipinfo = new Payslipinfo.fromJson(objdata);
        });
        // print(slipinfo.engName);
      } else {
        //   print('error');
      }
    }
  }

  //final formatCurrency = new NumberFormat.simpleCurrency();
  final formatCurrency = new NumberFormat("#,##0.00", "th_TH");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: UIHelper.WHITE,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          CustomPaint(
            painter: CurvePainter(),
            child: Container(
              height: UIHelper.dynamicHeight(250.0),
            ),
          ),
          Text(
            'ใบแจ้งเงินเดือน',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Container(height: 1, color: Colors.grey),
          buildHeader(widget.profile),
          // Text('รายการเงินได้'),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width * 0.5) - 10,
                  child: DataTable(columns: [
                    DataColumn(
                        label: Container(
                      //padding: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width * 0.5) - 50,
                      // color: Colors.blueAccent,
                      child: Text(
                        'รายการเงินได้',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.0),
                      ),
                    )),
                  ], rows: []),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width * 0.5) - 10,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Container(
                        // padding: EdgeInsets.all(1),
                        alignment: Alignment.center,
                        width: (MediaQuery.of(context).size.width * 0.5) - 50,
                        // color: Colors.blueAccent,
                        child: Text(
                          'รายการหัก',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12.0),
                        ),
                      )),
                    ],
                    rows: [],
                  ),
                ),
              ]),
          // Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         width: 200,
          //         child: DataTable(
          //           columns: [
          //             DataColumn(label: Text('รายการ')),
          //             DataColumn(label: Text('จำนวนเงิน')),
          //           ],
          //           rows: invoice.items
          //               .map((item) => DataRow(cells: [
          //                     DataCell(Text(
          //                       item.description,
          //                       softWrap: true,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 10.0),
          //                     )
          //                         //   Container(
          //                         //   padding: EdgeInsets.all(1.0),
          //                         //   alignment: Alignment.centerLeft,
          //                         //   //width: 50,
          //                         //   color: Colors.blueAccent,
          //                         //   child: Text(
          //                         //     item.description,
          //                         //     softWrap: true,
          //                         //     overflow: TextOverflow.ellipsis,
          //                         //     style: TextStyle(
          //                         //         fontWeight: FontWeight.w600,
          //                         //         fontSize: 10.0),
          //                         //   ),
          //                         // )
          //                         ),
          //                     DataCell(Text(
          //                       '${formatCurrency.format(item.quantity)}',
          //                       softWrap: true,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 10.0),
          //                     ))
          //                   ]))
          //               .toList(),
          //         ),
          //       ),
          //       Container(
          //         width: 200,
          //         child: DataTable(
          //           columns: [
          //             DataColumn(label: Text('รายการ')),
          //             DataColumn(label: Text('จำนวนเงิน')),
          //           ],
          //           rows: invoice.items
          //               .map((item) => DataRow(cells: [
          //                     DataCell(Text(
          //                       item.description,
          //                       softWrap: true,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 12.0),
          //                     )
          //                         //   Container(
          //                         //   alignment: Alignment.centerLeft,
          //                         //   width: 50,
          //                         //   child: Text(
          //                         //     item.description,
          //                         //     softWrap: true,
          //                         //     overflow: TextOverflow.ellipsis,
          //                         //     style: TextStyle(
          //                         //         fontWeight: FontWeight.w600,
          //                         //         fontSize: 12.0),
          //                         //   ),
          //                         // )
          //                         ),
          //                     DataCell(Text(
          //                       '${formatCurrency.format(item.quantity)}',
          //                       softWrap: true,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 12.0),
          //                     )
          //                         //   Container(
          //                         //   alignment: Alignment.centerRight,
          //                         //   width: 50,
          //                         //   child: Text(
          //                         //     item.quantity.toString(),
          //                         //     softWrap: true,
          //                         //     overflow: TextOverflow.ellipsis,
          //                         //     style: TextStyle(
          //                         //         fontWeight: FontWeight.w600,
          //                         //         fontSize: 12.0),
          //                         //   ),
          //                         // )
          //                         )
          //                   ]))
          //               .toList(),
          //         ),
          //       ),
          //     ]
          //     ),
          Container(height: 0.5, color: Colors.grey),
        ])));
  }
}

Widget buildHeader(Profile profile) => Container(
      padding: EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // buildCustomerAddress(invoice.customer),
              buildInfoleft(profile),
              buildInforend(profile),
            ],
          ),
        ],
      ),
    );
Widget buildInfoleft(Profile profile) {
  // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  final titles = <String>[
    'ชื่อ-นามสกุล:',
    'หน่วยงาน:',
    'เลขที่ผู้เสียภาษี:',
    'วันที่จ่ายเงินเดือน',
    'สถาณที่ปฎิบัติงาน:'
  ];
  final data = <String>[
    profile.thaiName,
    profile.orgCode,
    profile.orgName,
    Utils.formatDate(DateTime.now()),
    // Utils.formatDate(info.dueDate),
    profile.thaiName,
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(titles.length, (index) {
      final title = titles[index];
      final value = data[index];

      return buildText(title: title, value: value, width: 180);
    }),
  );
}

// Widget buildOfPayment(Invoice invoice) {
//   final data = invoice.items.map((item) {
//     final total = item.unitPrice * item.quantity * (1 + item.vat);
//     var x = item.quantity.toDouble();
//     return [
//       item.description,
//       // Utils.formatDate(item.date),
//       Utils.formatPrice(x),
//       // '\$ ${item.unitPrice}',
//       // '${item.vat} %',
//       // '\$ ${total.toStringAsFixed(2)}',
//     ];
//   }).toList();
//   final headerset = [
//     'รายการ',
//     'จำนวน',
//   ];
//   return Expanded(
//       child: Container(
//           child: Table(
//     headers: headerset,
//     data: data,
//     border: null,
//     headerStyle: TextStyle(fontWeight: FontWeight.bold),
//     headerDecoration: BoxDecoration(color: Colors.grey),
//     cellHeight: 30,
//     cellAlignments: {
//       0: Alignment.centerLeft,
//       1: Alignment.centerRight,
//       2: Alignment.center,
//       3: Alignment.centerRight,
//       4: Alignment.centerRight,
//       5: Alignment.centerRight,
//     },
//   )));
// }
Widget buildInforend(Profile profile) {
  // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  final titles = <String>[
    'เลขประจำตัวพนักงาน:',
    'ฝ่าย:',
    'เลขประกันสังคม:',
  ];
  final data = <String>[profile.code, profile.thaiName, profile.code];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(titles.length, (index) {
      final title = titles[index];
      final value = data[index];

      return buildText(title: title, value: value, width: 180);
    }),
  );
}

Widget buildText({
  String title,
  String value,
  double width = double.infinity,
  TextStyle titleStyle,
  bool unite = false,
}) {
  final style =
      titleStyle ?? TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold);
  final styleinfo = titleStyle ?? TextStyle(fontSize: 10.0);
  return Container(
    width: width,
    child: Row(
      children: [
        Expanded(child: Text(title, style: style)),
        Text(value, style: unite ? style : styleinfo),
      ],
    ),
  );
}

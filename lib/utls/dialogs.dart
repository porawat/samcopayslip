import 'package:flutter/material.dart';
import 'package:samcopayslip/utls/custom_dialog_box.dart';

class Dialogs extends StatefulWidget {
  @override
  _DialogsState createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Dialog In Flutter"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
            child: ElevatedButton(
          child: Text('check update'),
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: "ตรวจพบเวอร์ชั่นใหม่",
                    descriptions:
                        "จำเป็นต้อง Upgrade เพื่อปรับปรุงประสิทธิภาพการทำงาน",
                    text: "ตกลง",
                    cancel: "ยกเลิก",
                  );
                });
          },
        )

            //  ElecatedButton(
            //   onPressed: () {
            //     showDialog(
            //         barrierDismissible: false,
            //         context: context,
            //         builder: (BuildContext context) {
            //           return CustomDialogBox(
            //             title: "ตรวจพบเวอร์ชั่นใหม่",
            //             descriptions:
            //                 "จำเป็นต้อง Upgrade เพื่อปรับปรุงประสิทธิภาพการทำงาน",
            //             text: "ตกลง",
            //             cancel: "ยกเลิก",
            //           );
            //         });
            //   },
            //   child: Text("Custom Dialog"),
            // ),
            ),
      ),
    );
  }
}

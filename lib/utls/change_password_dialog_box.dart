import 'package:flutter/material.dart';
import 'package:samcopayslip/utls/const.dart';

class ChangePasswordDialogBox extends StatefulWidget {
  final String title, descriptions, text, cancel;
  final Image img;
  final Widget page;
  const ChangePasswordDialogBox(
      {Key key,
      this.title,
      this.descriptions,
      this.text,
      this.page,
      this.img,
      this.cancel})
      : super(key: key);

  @override
  _ChangePasswordDialogBoxState createState() =>
      _ChangePasswordDialogBoxState();
}

class _ChangePasswordDialogBoxState extends State<ChangePasswordDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonTheme(
                        minWidth: 35.0,
                        height: 40.0,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused))
                                return Colors.red[100];
                              if (states.contains(MaterialState.hovered))
                                return Colors.yellowAccent;
                              if (states.contains(MaterialState.pressed))
                                return Colors.red;
                              return null; // Defer to the widget's default.
                            }),
                          ),
                          onPressed: () {
                            // Navigator.of(context).pop();
                          },
                          child: Text(widget.cancel),
                        )),
                    SizedBox(width: 8.0),
                    ButtonTheme(
                        minWidth: 35.0,
                        height: 40.0,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused))
                                return Colors.red;
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              if (states.contains(MaterialState.pressed))
                                return Colors.blue[900];
                              return null; // Defer to the widget's default.
                            }),
                          ),
                          onPressed: () async {
                            //  print(widget.url);
                            try {
                              await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.page,
                                  ),
                                  (Route<dynamic> route) => false);
                            } catch (e) {
                              // print('upgrader: launch to app store failed: $e');
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(widget.text),
                        ))
                  ])
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/icon/icon.png")),
          ),
        ),
      ],
    );
  }
}

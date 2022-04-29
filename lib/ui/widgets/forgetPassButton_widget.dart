import 'package:flutter/material.dart';

class ForgetPasswordButton extends StatelessWidget {
  final Color color;
  final double rightPadding;
  const ForgetPasswordButton({Key key, this.color, this.rightPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, rightPadding, 0),
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              child: Text('Button'),
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                  textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 30))),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';

class NoDataWidgets extends StatelessWidget {
  String text;
  NoDataWidgets({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Text(text)
        ],
      )
    );
  }
}

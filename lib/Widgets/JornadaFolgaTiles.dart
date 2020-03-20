import 'package:flutter/material.dart';

class JornadaFolgaTiles extends StatelessWidget {

  final snapshot;

  const JornadaFolgaTiles({Key key, this.snapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Folga",
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}

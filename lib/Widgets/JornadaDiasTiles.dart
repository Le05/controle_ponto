import 'package:flutter/material.dart';


class JornadaDiasTiles extends StatelessWidget {
  final snapshot;
  final opcao;
  final dia;

  const JornadaDiasTiles({Key key, this.snapshot, this.opcao, this.dia}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(child:
      Column(
              children: <Widget>[
                Text(
                  dia,
                  style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[0]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[1]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[2]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[3]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[4]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[5]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data[6]["ehFolga"] == false ? snapshot.data[0][opcao] : "Folga",
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
    );
  }
}
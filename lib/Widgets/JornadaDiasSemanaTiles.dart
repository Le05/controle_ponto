import 'package:flutter/material.dart';

// builda os textos do irão aparecer na tela
class JornadaDiasSemanaTiles extends StatelessWidget {
  final snapshot;
  final String opcao;

  const JornadaDiasSemanaTiles({Key key, this.snapshot,this.opcao})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          "Dia",
          style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[0][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[1][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[2][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[3][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[4][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[5][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot.data[6][opcao],
          style: TextStyle(fontSize: 19),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ));
  }
}

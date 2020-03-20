import 'package:controle_ponto/screens/Home.dart';
import 'package:flutter/material.dart';

Future<void> mensagemUpdatePassword(BuildContext context, String mensagem,String title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(title)],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("$mensagem"),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<void> mensagemUpdatePasswordOk(BuildContext context, String mensagem,String title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(title)],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("$mensagem"),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
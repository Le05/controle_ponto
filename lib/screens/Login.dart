import 'package:controle_ponto/screens/Acessar.dart';
import 'package:controle_ponto/screens/FirstAcess.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    String orientacao = MediaQuery.of(context).orientation.toString();
    print(orientacao);
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height, // / 1.90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black45]),
            )),
        Positioned(
          left: 10,
          right: 10,
          height: orientacao == "Orientation.portrait"
              ? MediaQuery.of(context).size.height /3
              : MediaQuery.of(context).size.height / 2,
          top: MediaQuery.of(context).size.height / 2.5,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height/15,
                    width: MediaQuery.of(context).size.width,
                  ),
                  ButtonTheme(
                      buttonColor: Colors.black,
                      height: orientacao == "Orientation.portrait"
                          ? MediaQuery.of(context).size.height / 13
                          : MediaQuery.of(context).size.height / 8, //40,
                      minWidth: MediaQuery.of(context).size.width / 1.5,
                      child: RaisedButton(
                        child: Text("Primeiro Acesso ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FirstAcess()));
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                      buttonColor: Colors.black,
                      height: orientacao == "Orientation.portrait"
                          ? MediaQuery.of(context).size.height / 13
                          : MediaQuery.of(context).size.height / 8, //40, //40,
                      minWidth: MediaQuery.of(context).size.width / 1.5,
                      child: RaisedButton(
                        child: Text("Acessar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Acessar()));
                        },
                      )),
                ],
              )),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 7,
          child: Container(
            child: Image.asset("images/ikpontoApp.png"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
          ),
        )
      ],
    );
  }
}

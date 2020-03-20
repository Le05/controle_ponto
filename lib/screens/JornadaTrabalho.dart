import 'package:controle_ponto/Webservice/RequestJornada.dart';
import 'package:controle_ponto/Widgets/JornadaDiasSemanaTiles.dart';
import 'package:controle_ponto/Widgets/JornadaDiasTiles.dart';
import 'package:flutter/material.dart';

class JornadaTrabalho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String orientacao = MediaQuery.of(context).orientation.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Jornada de trabalho"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getJornada(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Stack(
              children: <Widget>[
                //  Image.asset("images/postore.jpg",fit: BoxFit.cover,height: 900,),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                          child: Icon(Icons.wifi, size: 80, color: Colors.red)),
                    ),
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                )
              ],
            );
          }
          if (!snapshot.hasData) {
            return Stack(
              children: <Widget>[
                //Image.asset("images/postore.jpg",fit: BoxFit.cover,height: 900,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
          return Stack(children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height, // / 1.90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.black45]),
                )),
            Container(
                child: Card(
                  margin: orientacao == "Orientation.portrait" ? 
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 7,bottom: MediaQuery.of(context).size.height / 3.2):
                  EdgeInsets.only(top: 0,left: MediaQuery.of(context).size.width / 5,right: MediaQuery.of(context).size.width / 5,bottom: 10),
                    child: ListView(
                      padding: EdgeInsets.only(top: 10),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                  JornadaDiasSemanaTiles(key: key,snapshot: snapshot,opcao: "diaDaSemana",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "entrada1",dia: "Entrada1",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "saida1",dia: "Saida1",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "entrada2",dia: "Entrada2",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "saida2",dia: "Saida2",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "entrada3",dia: "Entrada3",),
                  SizedBox(width: 10,),
                  JornadaDiasTiles(key: key,snapshot: snapshot,opcao: "saida3",dia: "Saida3",)

            ]
            ))),
          ]);
        },
      ),
    );
  }
}

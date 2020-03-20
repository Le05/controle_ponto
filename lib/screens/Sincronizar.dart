import 'package:controle_ponto/Dialogs/DialogSincronizar.dart';
import 'package:controle_ponto/Funcoes/rotacaoTela.dart';
import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/Webservice/RequestAuthFace.dart';
import 'package:controle_ponto/Webservice/RequestSincronizar.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SincronizarDados extends StatefulWidget {
  @override
  _SincronizarDadosState createState() => _SincronizarDadosState();
}

class _SincronizarDadosState extends State<SincronizarDados> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    Helpers helpers = Helpers();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Sincronizar"),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: helpers.getAllPontosNotSync(),
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
                              child: Icon(Icons.wifi,
                                  size: 80, color: Colors.red)),
                        ),
                        Text(
                          "Por Favor,verifique sua conexão com a internet!",
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
              // retornar os pontos a serem sincronizados
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.15,
                child: Stack(
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
                      top: 20, //MediaQuery.of(context).size.height /2,
                      left: 20,
                      right: 10,
                      child: Text(
                        "Existe cerca de ${snapshot.data.length} registros que não foram sincronizados",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 9),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 9,
                              right: MediaQuery.of(context).size.width / 9,
                              top: 15),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Data: ${snapshot.data[index].dataPontos}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Hora: ${snapshot.data[index].horaPontos}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height / 1.3,
                        left: MediaQuery.of(context).size.width / 4,
                        child: ButtonTheme(
                          buttonColor: Colors.black,
                          minWidth: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: RaisedButton(
                            child: Text(
                              "Sincronizar",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () async {
                              if (snapshot.data.length < 1) {
                                await mensagemSemDados(
                                    context,
                                    "Não existe nenhuma marcação para sincronizar",
                                    "Sem Sincronização");
                              } else {
                                pr.style(message: "Sincronizando dados...");
                                pr.show();
                                //valida se tem conexão com a internet fazendo requisição no google
                                await verificaConexao().then((onValue) async {
                                  await sincronizar().then((onValue) {
                                    print(onValue);
                                    setState(() {
                                      print("atualizando tela");
                                    });
                                    pr.hide();
                                  }).catchError((onError) async {
                                    pr.hide();
                                    await mensagemErrorSinc(
                                        context, "Erro ao sincronizar", "Erro");
                                    print(onError);
                                  });
                                }).catchError((onError) async {
                                  pr.hide();
                                  await mensagemErrorSinc(
                                      context, "Erro ao sincronizar", "Erro");
                                  print(onError);
                                });
                              }
                            },
                          ),
                        ))
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

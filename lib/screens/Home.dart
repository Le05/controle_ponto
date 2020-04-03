import 'package:controle_ponto/Funcoes/FuncoesLogin.dart';
import 'package:controle_ponto/Funcoes/rotacaoTela.dart';
import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/Webservice/RequestDadosUser.dart';
import 'package:controle_ponto/models/UserModel.dart';
import 'package:controle_ponto/screens/AlterarSenha.dart';
import 'package:controle_ponto/screens/JornadaTrabalho.dart';
import 'package:controle_ponto/screens/Login.dart';
import 'package:controle_ponto/screens/MarcarPonto.dart';
import 'package:controle_ponto/screens/Sincronizar.dart';
import 'package:controle_ponto/screens/SobreApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  Helpers helpers = Helpers();
  User user = User();
  User dadosuser;
  String nome = "Carregando";

  @override
  void initState() {
    super.initState();
    _validaExisteDados();
  }

  _validaExisteDados({bool pegaUserName}) async {
    prefs = await SharedPreferences.getInstance();
    var dados = await helpers.getUser(int.parse(prefs.getString("id")));
    //if(pegaUserName != true){
    if (dados == null) {
      var dados =
          await getDadosUser(prefs.getString("key"), prefs.getString("id"));
      user.id_userUser = prefs.getString("id");
      user.tokenUser = prefs.getString("key");
      user.loginUser = prefs.getString("login");
      user.senhaUser = prefs.getString("senha");
      user.expireToken = prefs.getString("expiracao_key");
      user.adminUser = prefs.getString("admin");
      user.foto64User = prefs.getString("foto64");
      user.cnpjUser = dados["cnpj"];
      user.nomeUser = dados["nome"];
      user.pisUser = dados["pis"];
      user.numSerieUser = deviceID;
      user.grupoUser = prefs.getString("grupo");
      await helpers.saveUser(user);
      dadosuser = await helpers.getUser(int.parse(prefs.getString("id")));
      // salva os dados no banco
    } else {
      dadosuser = await helpers.getUser(int.parse(prefs.getString("id")));
    }
    //}else{
    //  return dadosuser = await helpers.getUser(int.parse(prefs.getString("id")));;
    //}
    setState(() {
      nome = dadosuser.nomeUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    enableRotation();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Ultimos Pontos",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
            child: Container(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Bem vindo(a) $nome",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.mode_edit,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Marcar Ponto",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MarcarPonto()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.settings_backup_restore,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Alterar Senha",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlterarSenha()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.apps,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Jornada de trabalho",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JornadaTrabalho()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.cached,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Sincronizar dados",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SincronizarDados()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Sobre o app",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SobreApp()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Sair",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        onPressed: () {
                          //prefs.clear();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.black38],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        )),
        body: WillPopScope(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: FutureBuilder(
              future: getPontos(),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                if (snapshot.data["Pontos"].length == 0) {
                  return Container(
                    child: Center(
                      child: Text(
                        "Nenhum ponto marcado ainda!!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
                return Stack(
                  children: <Widget>[
                    /*Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height, // / 1.90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.black45]),
                        )),*/
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        itemCount: snapshot.data["Pontos"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            elevation: 10,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 15, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      /*Text(
                                        "Data do Ponto:",
                                        style: TextStyle(fontSize: 17),
                                      ),*/
                                      Text("${snapshot.data["Pontos"][index].dia}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ],
                                  ),
                                  Divider(
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/input.png",
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Entrada1",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            //SizedBox(width: MediaQuery.of(context).size.width / 3,),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].entrada1 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].entrada1}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        /*SizedBox(
                                          width: MediaQuery.of(context).size.width / 5,
                                        ),*/
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/output.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Saida1",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Container(
                                               margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].saida1 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].saida1}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    height: 10,
                                  ),
                                snapshot.data["qtdPontos"] >= 2 ?
                                Container(
                                    margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/input.png",
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Entrada2",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            //SizedBox(width: MediaQuery.of(context).size.width / 3,),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].entrada2 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].entrada2}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        /*SizedBox(
                                          width: MediaQuery.of(context).size.width / 5,
                                        ),*/
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/output.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Saida2",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Container(
                                               margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].saida2 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].saida2}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ):Container(),
                                  snapshot.data["qtdPontos"] >= 2 ?
                                  SizedBox(
                                    height: 5,
                                  ):Container(),
                                  snapshot.data["qtdPontos"] >= 2 ?
                                  Divider(
                                    height: 10,
                                  ):Container(),
                                  snapshot.data["qtdPontos"] == 3 ?
                                 Container(
                                    margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/input.png",
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Entrada3",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            //SizedBox(width: MediaQuery.of(context).size.width / 3,),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].entrada3 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].Entrada3}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        /*SizedBox(
                                          width: MediaQuery.of(context).size.width / 5,
                                        ),*/
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "images/output.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Saida3",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Container(
                                               margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      13),
                                              child: Text(
                                                  snapshot.data["Pontos"][index].saida3 !=
                                                          null
                                                      ? "${snapshot.data["Pontos"][index].Saida3}"
                                                      : "Falt.Marcação",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ):Container(),
                                  snapshot.data["qtdPontos"] == 3 ?
                                  SizedBox(
                                    height: 5,
                                  ):Container(),
                                  snapshot.data["qtdPontos"] == 3 ?
                                  Divider(
                                    height: 10,
                                  ):Container(),
                                  snapshot.data["qtdPontos"] == 3 ?
                                  SizedBox(
                                    height: 10,
                                  ):Container()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          onWillPop: () {
            return SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          },
        ));
  }
}

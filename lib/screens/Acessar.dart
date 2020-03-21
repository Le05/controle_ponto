import 'package:controle_ponto/Dialogs/DialogLogin.dart';
import 'package:controle_ponto/Funcoes/FuncoesLogin.dart';
import 'package:controle_ponto/Funcoes/rotacaoTela.dart';
import 'package:controle_ponto/Webservice/RequestLogin.dart';
import 'package:controle_ponto/Webservice/RequestSincronizar.dart';
import 'package:controle_ponto/screens/Home.dart';
import 'package:controle_ponto/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// tela de validação do codigo e login

class Acessar extends StatefulWidget {
  @override
  _AcessarState createState() => _AcessarState();
}

class _AcessarState extends State<Acessar> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  ProgressDialog pr;
  bool _conectado;

  @override
  Widget build(BuildContext context) {
    enableRotation();
    String orientacao = MediaQuery.of(context).orientation.toString();
    print(orientacao);
    // instancio o objeto do progress para usar ele quando o botao acessar for apertado
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
      body: SingleChildScrollView(
        child: WillPopScope(
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
              Form(
                key: _formkey,
                child: Container(
                  margin: orientacao == "Orientation.portrait"
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4,
                          left: 10,
                          right: 10)
                      : EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 6,
                          left: 10,
                          right: 10),
                  height: orientacao == "Orientation.portrait"
                      ? MediaQuery.of(context).size.height / 2.3
                      : MediaQuery.of(context).size.height / 1.3,
                  child: FutureBuilder<Map>(
                      future: buscaUltimoUsuarioLogado(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        //validaçaõ necessaria para que nao fique alterando o checkbox e nem o textinput
                        // toda hora
                        if(snapshot.data["executada"] == 1){
                            _loginController.text = snapshot.data["login"];
                        }else{
                          print('passou');
                        }
                        /*snapshot.data["executada"] == 1 ?
                          _loginController.text = snapshot.data["login"] :
                          print("passou"); 
                        */
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: _loginController,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "Preencha corretamente!";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    //suffixIcon: Icon(Icons.remove_red_eye),
                                    prefixIcon: Icon(Icons.account_circle),
                                    labelText: "Login",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    border: OutlineInputBorder(),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _senhaController,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "Preencha corretamente!";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    //suffixIcon: Icon(Icons.remove_red_eye),
                                    prefixIcon: Icon(Icons.lock),
                                    labelText: "Senha",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    border: OutlineInputBorder(),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                             /* Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Checkbox(
                                      onChanged: (bool resposta) {
                                        setState(() {
                                          _conectado = resposta;
                                        });
                                      },
                                      value: _conectado,
                                    ),
                                    Text("Salvar Login")
                                  ],
                                ),*/
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 30,
                              ),
                              ButtonTheme(
                                  buttonColor: Colors.black,
                                  height: 50,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: RaisedButton(
                                    child: Text("Entrar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        )),
                                    // shape: StadiumBorder(),
                                    onPressed: () async {
                                      // instancia a preferences
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (_formkey.currentState.validate()) {
                                        pr.style(message: "Autenticando");
                                        pr.show();
                                        await login(_loginController.text,
                                                _senhaController.text)
                                            .then((onValue) async {
                                          print(onValue);
                                          //seta algumas preferencias para utiliza-las depois
                                          prefs.clear();
                                          prefs.setBool("conectado", _conectado);
                                          prefs.setString("id", onValue["id"]);
                                          prefs.setString(
                                              "login", _loginController.text);
                                          prefs.setString(
                                              "senha", _senhaController.text);
                                          prefs.setString(
                                              "key", onValue["token"]);
                                          prefs.setString("admin",
                                              onValue["admin"].toString());
                                          prefs.setString("expiracao_key",
                                              onValue["expiracaoToken"]);
                                          prefs.setString(
                                              "grupo", onValue["grupo"]);
                                          await helpers.updateKeyUser(
                                              onValue["expiracaoToken"],
                                              onValue["token"],
                                              onValue["id"]);
                                          // inserir key no banco para verificar depois
                                          pr.hide();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home()));
                                        }).catchError((onError) async {
                                          prefs.clear();
                                          await loginOff(_loginController.text,
                                                  _senhaController.text)
                                              .then((onValue) async {
                                            if (onValue == 1) {
                                              pr.hide();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home()));
                                            } else if (onValue == 0 ||
                                                onValue == 2) {
                                              pr.hide();
                                              await mensagemErroLogin(context,
                                                  "Não foi possivel validar o seu acesso!! Por favor, tente novamente com internet");
                                            }
                                          });
                                        });
                                      }
                                    },
                                  )),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
          onWillPop: () {
            return Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
    );
  }
}

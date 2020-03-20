import 'package:controle_ponto/Dialogs/DialogsFirstAccess.dart';
import 'package:controle_ponto/Webservice/RequestLogin.dart';
import 'package:controle_ponto/screens/Login.dart';
import 'package:controle_ponto/screens/NovaSenha.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

//tela de primeiro acesso, onde coloca senha e login
class FirstAcess extends StatefulWidget {
  @override
  _FirstAcessState createState() => _FirstAcessState();
}

class _FirstAcessState extends State<FirstAcess> {
  final _loginController = TextEditingController();
  final _codigoValidacaoController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ProgressDialog pr;
    // instancio o objeto do progress para usar ele quando o botao acessar for apertado
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    String orientacao = MediaQuery.of(context).orientation.toString();
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
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              // obscureText: true,
                              controller: _codigoValidacaoController,
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
                                labelText: "Codigo de validação",
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ButtonTheme(
                              buttonColor: Colors.black,
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width / 1.7,
                              child: RaisedButton(
                                child: Text("Acessar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                                // shape: StadiumBorder(),
                                onPressed: () async {
                                  // passo uma message para o progress e executo ele
                                  pr.style(message: "Autenticando...");
                                  pr.show();

                                  // valida os campos de login e codigo, se estiverem vazios
                                  // ele retorna uma mensagem em baixo dos campos
                                  if (_formkey.currentState.validate()) {
                                    await firstAcessLogin(_loginController.text,
                                            _codigoValidacaoController.text)
                                        .then((onValue) async {
                                      await Future.delayed(
                                          Duration(seconds: 2));
                                      pr.hide();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NovaSenha(
                                                  _loginController.text,
                                                  _codigoValidacaoController
                                                      .text)));
                                    }).catchError((onError) async {
                                      pr.hide();
                                      await mensagemErroValidacao(context,
                                          onError.response.data["erro"]);
                                    });
                                  }
                                },
                              )),
                        ],
                      )),
                ),
              )
            ],
          ),
          onWillPop: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
    );
  }
}

import 'package:controle_ponto/Dialogs/DialogsFirstAccess.dart';
import 'package:controle_ponto/Webservice/RequestLogin.dart';
import 'package:controle_ponto/screens/AddFoto.dart';
import 'package:controle_ponto/screens/FirstAcess.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NovaSenha extends StatefulWidget {
  NovaSenha(
    this.login,
    this.codigoValida,
  );
  final String codigoValida, login;

  @override
  _NovaSenhaState createState() => _NovaSenhaState(login, codigoValida);
}

class _NovaSenhaState extends State<NovaSenha> {
  _NovaSenhaState(this.login, this.codigoValida);
  final String codigoValida, login;
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
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
        child: Column(
          children: <Widget>[
            Stack(
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
                  child: Container(margin: orientacao == "Orientation.portrait"
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4,
                          left: 10,
                          right: 10)
                      : EdgeInsets.only(top: MediaQuery.of(context).size.height / 6,left: 10,right: 10),
                  height:  orientacao == "Orientation.portrait"
                      ? MediaQuery.of(context).size.height / 2.3 :
                        MediaQuery.of(context).size.height /1.3,
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
                                obscureText: true,
                                controller: _senhaController,
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "Preencha corretamente!";
                                  } else if (text.length <= 7 ||
                                      text.length >= 11) {
                                    return "O valor minimo de caracteres é 8, e máximo de 10";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  //suffixIcon: Icon(Icons.remove_red_eye),
                                  prefixIcon: Icon(Icons.account_circle),
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
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                obscureText: true,
                                controller: _confirmaSenhaController,
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
                                  labelText: "Confirmar Senha",
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
                            ButtonTheme(
                                buttonColor: Colors.black,
                                height: 50,
                                minWidth:
                                    MediaQuery.of(context).size.width / 1.7,
                                child: RaisedButton(
                                  child: Text("Acessar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                  // shape: StadiumBorder(),
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      pr.style(message: "Verificando senhas");
                                      pr.show();
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      // verifica se ambas senhas estão iguais
                                      if (_senhaController.text ==
                                          _confirmaSenhaController.text) {
                                        pr.update(
                                            message: "Senhas Verificadas");
                                          //caso estejam iguais, ele envia a requisição para o servidor na funcão
                                          // abaixo
                                        updatePasswordFirstAcess(
                                                login,
                                                codigoValida,
                                                _senhaController.text,
                                                _confirmaSenhaController.text)
                                            .then((onValue) async {
                                              pr.update(message: "Redirecionando para tela de login...");
                                              await Future.delayed(
                                          Duration(seconds: 1));
                                          // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Acessar()));
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AddFoto(marcar: false,)));
                                        }).catchError((onError) async {
                                          pr.hide();
                                          await mensagemErroSenha(context,onError.response.data["erro"]);
                                        });
                                      } else {
                                        pr.hide();
                                        await mensagemErroSenha(context,"Por Favor,verifique se as senhas estão iguais e tente novamente!!");
                                      }
                                    }
                                  },
                                )),
                          ],
                        )),
                  ),
                )
              ],
            )
          ],
        ),
        onWillPop: () {
          return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => FirstAcess()));
        },
      )),
    );
  }
}

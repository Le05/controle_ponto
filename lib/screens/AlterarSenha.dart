import 'package:controle_ponto/Dialogs/DialogAlterarSenha.dart';
import 'package:controle_ponto/Dialogs/DialogsFirstAccess.dart';
import 'package:controle_ponto/Webservice/RequestAlterarSenha.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AlterarSenha extends StatefulWidget {
  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final _formkey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _repetirsenhaController = TextEditingController();
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Alterar senha"),
      ),
      body: SingleChildScrollView(
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
              top: MediaQuery.of(context).size.height / 6,
              left: 10,
              right: 10,
              child: Form(
                key: _formkey,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: TextFormField(
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
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            labelText: "Senha",
                            labelStyle: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: TextFormField(
                          controller: _repetirsenhaController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Preencha corretamente!";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.remove_red_eye),
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            labelText: "Repetir Senha",
                            labelStyle: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      ButtonTheme(
                        buttonColor: Colors.black,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        child: RaisedButton(
                          child: Text(
                            "Alterar",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () async {
                            pr.style(message: "Validando senha...");
                            pr.show();
                            await Future.delayed(Duration(seconds: 2));
                            // verifica se ambas senhas estão iguais
                            if (_senhaController.text ==
                                _repetirsenhaController.text) {
                                   await updatePassword(_senhaController.text,_repetirsenhaController.text).then((onValue) async {
                                     print(onValue);
                                     pr.hide();
                                     await mensagemUpdatePasswordOk(context,"A senha foi alterada com sucesso","Senha Alterada!!");
                                   }).catchError((onError) async {
                                     pr.hide();
                                     if(onError.type.index == 5)
                                        await mensagemUpdatePassword(context, "Erro ao alterar a senha,verifique sua conexão com internet", "Erro Alterar Senha");
                                     else if(onError.response.statusCode == 400)
                                       await mensagemUpdatePassword(context,onError.response.data["erro"] ,"Erro Alterar Senha");
                                     print(onError);
                                   });
                                }else{
                                  pr.hide();
                                  await mensagemErroSenha(context, "As Senhas não conferem!!");
                                }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

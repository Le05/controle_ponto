import 'dart:convert';
import 'dart:io';

import 'package:controle_ponto/Dialogs/DialogFoto.dart';
import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/screens/Acessar.dart';
import 'package:controle_ponto/screens/MarcarPonto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoto extends StatefulWidget {
  AddFoto({this.marcar});
  final bool marcar;

  @override
  _AddFotoState createState() => _AddFotoState(marcar);
}

class _AddFotoState extends State<AddFoto> {
  _AddFotoState(this.marcar);
  final bool marcar;
  File _image;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
      body: WillPopScope(
        child: SafeArea(
          child: SingleChildScrollView(
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
              top: 25,
              child: Text("Selecione uma foto onde seu rosto esteja \nbem visível!!",style:TextStyle(color: Colors.white,fontSize: 17)),
            ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:MediaQuery.of(context).size.height / 5.5),
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    child: _image == null
                        ? Center(
                            child: Text('Nenhuma imagem selecionada'),
                          )
                        : Image.file(_image),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /*ButtonTheme(
                        buttonColor: Colors.black,
                        child: RaisedButton(
                          child: Text(
                            "Adicionar foto da galeria",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            getImage(1);
                          },
                        ),
                      ),*/
                      ButtonTheme(
                        buttonColor: Colors.black,
                        child: RaisedButton(
                          child: Text(
                            "Tirar uma foto",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            getImage(0);
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 3,
                      height: 55,//MediaQuery.of(context).size.height / 10,
                          buttonColor: Colors.black,
                          child: RaisedButton(
                            child: Text(
                              "Enviar foto",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if(_image == null){
                                await mensagemSemFoto(context,"Por Favor, insira uma foto!!");
                              }else{
                                pr.style(message: "Enviando foto...");
                                pr.show();
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("foto64",converterBase64(_image));
                              await Future.delayed(Duration(seconds: 2));
                              Helpers helpers = Helpers();
                              helpers.updateFoto64(prefs.getString("foto64"), prefs.getString("id"));
                              pr.hide();
                              if(marcar == true){
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MarcarPonto()));
                              }else{
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Acessar()));
                              }
                              }
                            },
                          ),
                        ),
                  )
                ],
              ),
            ],
          )),
        ),
        onWillPop: () {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AddFoto()));
        },
      ),
    );
  }

  Future getImage(int tipo) async {
    var image;
    //se o tipo for 0, ele abre a camera, se for 1,ele abre a galeria
    tipo == 0
        ? image = await ImagePicker.pickImage(source: ImageSource.camera ,maxHeight: 1280, maxWidth: 720)
        : image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  converterBase64(File file) {
  var base64Image, fileName;
  if (file != null) {
    base64Image = base64.encode(file.readAsBytesSync());
    //fileName = file.path.split("/").last;
  }
  return base64Image;
}
}

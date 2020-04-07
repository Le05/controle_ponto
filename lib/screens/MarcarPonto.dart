import 'dart:io';
//import 'package:app_settings/app_settings.dart';
import 'package:controle_ponto/Dialogs/DialogMarcaPonto.dart';
import 'package:controle_ponto/Funcoes/FuncoesMarcaPonto.dart';
import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/Webservice/RequestAuthFace.dart';
import 'package:controle_ponto/Webservice/RequestMarcaPonto.dart';
import 'package:controle_ponto/models/MarcarPontoModel.dart';
import 'package:controle_ponto/models/UserModel.dart';
import 'package:controle_ponto/screens/AddFoto.dart';
import 'package:controle_ponto/screens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarcarPonto extends StatefulWidget {
  @override
  _MarcarPontoState createState() => _MarcarPontoState();
}

class _MarcarPontoState extends State<MarcarPonto> {
  @override
  void initState() {
    super.initState();
    separaCaracteresData();
  }

  bool botaoMarcar = false;
  String dataHora, faceIdLocal, faceIdInstantaneo, dataAtual;
  bool isIdentical;
  double latitude, longitude, confiance;
  List<Placemark> endereco;
  Geolocator geolocator = Geolocator();
  ProgressDialog pr;
  File _image, imageFile;
  User dadosUser;

  @override
  Widget build(BuildContext context) {
    String orientacao = MediaQuery.of(context).orientation.toString();
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    Helpers helpers = Helpers();
    MarcaPonto marcaPonto = MarcaPonto();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Registro de Ponto",
          ),
          backgroundColor: Colors.black,
          leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
          },),
        ),
        body: WillPopScope(
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
                  left: 15,
                  right: 15,
                  top: orientacao == "Orientation.portrait"
                      ? MediaQuery.of(context).size.height / 10
                      : MediaQuery.of(context).size.height / 20,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Informações sobre o registro",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      dataHora != null
                                          ? "Horario: $dataHora"
                                          : "Horario:",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: orientacao == "Orientation.portrait"
                                ? MediaQuery.of(context).size.height / 5
                                : MediaQuery.of(context).size.height / 3.0,
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: Text(
                                          endereco != null
                                              ? "Rua: ${endereco[0].thoroughfare}"
                                              : "Endereço",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          endereco != null
                                              ? "Cidade: ${endereco[0].subAdministrativeArea}"
                                              : "Cidade",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder(
                                    future: verificaConexao(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Container(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text(
                                            "Sem conexão com a internet",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        );
                                      }
                                      if (!snapshot.hasData) {
                                        return Stack(
                                          children: <Widget>[
                                            //Image.asset("images/postore.jpg",fit: BoxFit.cover,height: 900,),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                      return ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                1.9,
                                        child: RaisedButton(
                                          child: Text(
                                            "Obter Localização",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                          onPressed: () async {
                                            pr.style(
                                                message:
                                                    "Buscando Localização...");
                                            pr.show();
                                            await verificaConexao()
                                                .then((onValue) async {
                                              var geo = await Geolocator()
                                                  .isLocationServiceEnabled();
                                              if (geo == true) {
                                                try {
                                                  Position position = await geolocator
                                                      .getCurrentPosition(
                                                          desiredAccuracy:
                                                              LocationAccuracy
                                                                  .best,
                                                          locationPermissionLevel:
                                                              GeolocationPermission
                                                                  .location);
                                                  endereco = await Geolocator()
                                                      .placemarkFromCoordinates(
                                                          position.latitude,
                                                          position.longitude);
                                                  setState(() {
                                                    latitude =
                                                        position.latitude;
                                                    longitude =
                                                        position.longitude;
                                                  });
                                                  pr.hide();
                                                } catch (e) {
                                                  pr.hide();
                                                  if (e.code ==
                                                      "PERMISSION_DENIED") {
                                                    await mensagemAcessoNegado(
                                                        context,
                                                        "É extremamente necessário o aplicativo ter acesso a localizaçao do smartphone !!!");
                                                    await geolocator
                                                        .getCurrentPosition();
                                                  } else if (e.code ==
                                                      "ERROR_GEOCODING_INVALID_COORDINATES") {
                                                    await mensagemErroGeral(
                                                        context,
                                                        "Ocorreu um erro ao obter a localização!! Por favor, verifique as permissões e se o GPS está ativo");
                                                  }
                                                }
                                              } else {
                                                pr.hide();
                                                // AppSettings.openLocationSettings();
                                              }
                                            }).catchError((onError) async {
                                              await mensagemErroGeral(
                                                  context, onError.toString());
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                orientacao == "Orientation.portrait" ? 20 : 5,
                          ),
                          ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width / 1.9,
                              child: RaisedButton(
                                  child: Text(
                                    "Marcar Ponto",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  onPressed: () async {
                                    pr.style(message: "Verificando conexão...");
                                    pr.show();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    dadosUser =
                                        await helpers.getUserForMarcaPonto(
                                            int.parse(prefs.getString("id")));
                                    List pontoSequencia =
                                        await verificaUltimoPonto(
                                            dadosUser.id_userUser, dataAtual);
                                    marcaPonto.id_userPontos =
                                        dadosUser.id_userUser;
                                    marcaPonto.dataPontos = dataAtual;
                                    marcaPonto.horaPontos = dataHora;
                                    marcaPonto.latitudePontos =
                                        latitude.toString();
                                    marcaPonto.longitudePontos =
                                        longitude.toString();
                                    marcaPonto.numeroPontos = pontoSequencia[0]
                                        .toString(); //numero do ponto atual
                                    marcaPonto.sequenciaPontos =
                                        pontoSequencia[1]
                                            .toString(); //sequencia atual
                                    marcaPonto.sincronizadoPontos = "true";
                                    await verificaConexao()
                                        .then((onValue) async {
                                      if (latitude != null &&
                                          longitude != null) {
                                        // inicio da verificação da foto
                                        dadosUser.foto64User = "64554654878";
                                        if (dadosUser.foto64User == null) {
                                          pr.hide();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddFoto(
                                                        marcar: true,
                                                      )));
                                        } else {
                                          // função comentada para nao abrir a camera para validar o usuario
                                          //await _getFace();
                                          // if correto é -> _image == null
                                          // o if abaixo é somente para enganar a validação
                                          if (dadosUser.foto64User == null) {
                                            pr.hide();
                                            await mensagemErroImage(context,
                                                'É necessario que seja tirado uma foto, para que seja feita a autenticação facial');
                                          } else {
                                            // função abaixo cria um arquivo file atraves de um string
                                            /* imageFile =
                                                await createFileFromString(
                                                    dadosUser.foto64User);*/
                                            //confiance =
                                            await reconhecimentoFacial(
                                                    imageFile, _image)
                                                .then((confiance) async {
                                              if (confiance > 0.6) {
                                                //pontoSequencia[2] -> idPonto que será inserido no banco
                                                //pontoSequencia[3] -> quantiade de zeros na sequencia
                                                await marcacaoPonto(
                                                        marcaPonto,
                                                        pontoSequencia[2]
                                                            .toString(),
                                                        pontoSequencia[3]
                                                            .toString(),
                                                        endereco)
                                                    .then((onValue) async {
                                                  await helpers
                                                      .savePonto(marcaPonto);
                                                  pr.hide();
                                                  await mensagemMarcacaoPonto(
                                                      context,
                                                      "Ponto marcado com sucesso!!",
                                                      "Sucesso");
                                                  print(
                                                      "salvo no banco e na api");
                                                }).catchError((onError) async {
                                                  marcaPonto
                                                          .sincronizadoPontos =
                                                      "false";
                                                  await helpers
                                                      .savePonto(marcaPonto);
                                                  pr.hide();
                                                  await mensagemMarcacaoPonto(
                                                      context,
                                                      "Ponto marcado somente internamente!!",
                                                      "Sucesso interno");
                                                  print(
                                                      "salvo no banco e deu erro na api");
                                                });
                                              } else {
                                                pr.hide();
                                                await mensagemErroImage(context,
                                                    "Erro ao autenticar, por favor tente novamente");
                                              }
                                            }).catchError((onError) async {
                                              pr.hide();
                                              await mensagemErroImage(context,
                                                  "Erro ao autenticar, contate a TI!!");
                                            });
                                          }
                                        }
                                      } else {
                                        pr.hide();
                                        await mensagemErroGeral(context,
                                            "É necessario obter a localização antes de marcar o ponto!!");
                                      }
                                    }).catchError((onError) async {
                                      pr.hide();
                                      print("salvo no banco");
                                      marcaPonto.sincronizadoPontos = "false";
                                      await helpers.savePonto(marcaPonto);
                                      await mensagemMarcacaoPonto(
                                          context,
                                          "Ponto marcado somente internamente!!",
                                          "Sucesso interno");
                                    });
                                  }))
                        ],
                      ))),
            ],
          ),
          onWillPop: () {
            return Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ));
  }

  /*_getFace() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }*/

  separaCaracteresData() {
    var data = DateTime.now().toString();
    var d = data.split(" ");
    dataAtual = d[0];
    var tempData = data.split("-");
    var temp = tempData[2].split(" ");
    //data = temp[0] + "/" + tempData[1] + "/" + tempData[0];
    temp = temp[1].split(":");
    dataHora = temp[0] + ":" + temp[1];
  }
}

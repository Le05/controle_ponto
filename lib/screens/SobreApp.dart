import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';


class SobreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Informações sobre o app"),backgroundColor: Colors.black,),
      body: Stack(
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
              FutureBuilder(
                future: getInformacoesDevice(),
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
                              child:
                                  Icon(Icons.wifi, size: 80, color: Colors.red)),
                        ),
                        Text(snapshot.error.toString(),
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
              return Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                height: MediaQuery.of(context).size.height /5,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Modelo do dispositivo: ${snapshot.data["modelo"]}",style: TextStyle(fontSize: 18),),
                      Text("Versão do app: 1.0.0",style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
              );
                },)
        ],
      ),
    );
  }
}

getInformacoesDevice() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosinfo;
    Map<String,dynamic> info;
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      info = {
        "modelo":androidInfo.model,
        };
      return info;
    } else if (Platform.isIOS) {
      iosinfo = await deviceInfo.iosInfo;
      info = {
        "modelo":iosinfo.model,
        };
      return info;
    }

}
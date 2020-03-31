import 'dart:io';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:controle_ponto/Webservice/RequestSincronizar.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

// verifica se foi marcado o checkbox na pagina de acessar
// e se a key ainda está valida, caso nao esteja, ele entra na pagina de acesso,
// caso não tenha marcado nada, ai ele fica nesssa pagina mesmo
/*Future verificaAutoLogin(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String dados = prefs.getString("autoLogin");
  if (dados == "true") {
    await getPontos().then((onValue) {
      prefs.setString("InvalidKey", "false");
       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
    }).catchError((onError) {
      //print(onError.error.message);
      var data = prefs.getString("expiracao_key");
      var dataSpli = data.split("/");
      var dataSpl = dataSpli[2].split(" ");
      var dataExp = DateTime(int.parse(dataSpl[0]), int.parse(dataSpli[1]),
          int.parse(dataSpli[0]));
      var diferenca = dataExp.difference(DateTime.now());
      if (diferenca.inMinutes < 0) {
        print(diferenca);
        prefs.setString("InvalidKey", "true");
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Acessar()));
      } else {
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
      }
    });
  } else if (dados == null) {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login()));
  } 
}*/

/*Future getNomeUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String nome = prefs.getString("");
  return user.nomeUser;
}*/

Future<int> loginOff(String login, String senha) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = await helpers.getUserLogin(login,senha);
  if(user != null){
  var data = user.expireToken;
  var dataSpli = data.split("/");
  var dataSpl = dataSpli[2].split(" ");
  var dataExp = DateTime(
      int.parse(dataSpl[0]), int.parse(dataSpli[1]), int.parse(dataSpli[0]));
  var diferenca = dataExp.difference(DateTime.now());
  if (diferenca.inMinutes < 0) {
    print(diferenca);
    /*Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Acessar()));*/
    return 0;
  } else {
    /*Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));*/
      prefs.setString("id", user.id_userUser);
      prefs.setString("login", login);
      prefs.setString("key", user.tokenUser);
      prefs.setString("admin", user.adminUser);
      prefs.setString("expiracao_key",user.expireToken);
      prefs.setString("grupo", user.grupoUser);
    return 1;
  }
  }else{
    return 2;
  }
}

Future validaSenhaOff(String login,String senha) async {

}


String deviceID;

Future<bool> buscarDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //AndroidDeviceInfo androidInfo;
  IosDeviceInfo iosinfo;
  if (Platform.isAndroid) {
    //androidInfo = await deviceInfo.androidInfo;
    //deviceID = await ImeiPlugin.getImei();
    deviceID = "RQ8KB0AZDEE";
    //deviceID = androidInfo.androidId;
  } else if (Platform.isIOS) {
    iosinfo = await deviceInfo.iosInfo;
    //deviceID = iosinfo.identifierForVendor;
    deviceID = "RQ8KB0AZDEE";
  }
  return true;
}
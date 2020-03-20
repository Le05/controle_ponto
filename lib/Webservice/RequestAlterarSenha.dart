import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


Dio dio = Dio();
//String baseUrl = "http://201.23.232.153:8080/ikponto";
String baseUrl = "https://ikponto.com.br";


updatePassword(String senha,String repetirSenha) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Response response;
  dio.options.connectTimeout = 5000;
  dio.options.headers = {
    'Authorization': 'Bearer ' + prefs.getString("key"),};
  response = await dio.post(baseUrl+"/servico/login/sc/alterar-senha",data: {
 "login":prefs.getString("login"), 
 "senha":senha, 
 "repetirSenha":repetirSenha
 });
 return response.data;
}


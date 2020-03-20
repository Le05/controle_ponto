import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();
//String baseUrl = "http://201.23.232.153:8080/ikponto";
String baseUrl = "https://ikponto.com.br";

getJornada() async {
SharedPreferences prefs = await SharedPreferences.getInstance();
Response response;
dio.options.connectTimeout = 5000;
dio.options.headers = {
    'Authorization': 'Bearer ' + prefs.getString("key"),
    'idFuncionario': prefs.getString("id")
  };
dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
response = await dio.post(baseUrl+"/servico/sessao/ponto/obter-horarios",data: {
  "idFuncionario":prefs.getString("id")
});

return response.data;
}
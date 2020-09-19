import 'package:controle_ponto/models/VariablesRunTime.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();

getJornada() async {
SharedPreferences prefs = await SharedPreferences.getInstance();
Response response;
dio.options.connectTimeout = 5000;
dio.options.headers = {
    'Authorization': 'Bearer ' + prefs.getString("key"),
    'idFuncionario': prefs.getString("id")
  };
dio.options.contentType = "application/x-www-form-urlencoded";
response = await dio.post(baseUrl+"/servico/sessao/ponto/obter-horarios",data: {
  "idFuncionario":prefs.getString("id"),
});

return response.data;
}
import 'package:controle_ponto/Webservice/RequestJornada.dart';
import 'package:controle_ponto/models/PontoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();
String baseUrl = "http://177.19.159.202:8080/ikponto";
//String baseUrl = "https://ikponto.com.br";
Map<String, dynamic> mapRetorno = {};
Future getDadosUser(String token, String id) async {
  Response response;
  dio.options.connectTimeout = 5000;
  dio.options.headers = {
    'Authorization': 'Bearer ' + token,
    'idFuncionario': id
  };
  dio.options.contentType = "application/x-www-form-urlencoded";
  response = await dio.post(
      baseUrl + "/servico/sessao/funcionario/obter-dados-gerais",
      data: {"idFuncionario": id});
  return response.data;
}

Future getPontos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Response response;
  dio.options.connectTimeout = 5000;
  dio.options.headers = {
    'Authorization': 'Bearer ' + prefs.getString("key"),
    'idFuncionario': prefs.getString("id")
  };
  dio.options.contentType = "application/x-www-form-urlencoded";
  response = await dio.post(baseUrl + "/servico/sessao/ponto/obter-pontos",
      data: {"idFuncionario": prefs.getString("id")});

  List<Ponto> pontos = [];
  List<Ponto> pontosReversos = [];
  for (var u in response.data) {
    Ponto ponto = Ponto(u["dia"], u["entrada1"], u["entrada2"], u["entrada3"],
        u["saida1"], u["saida2"], u["saida3"]);
    pontos.add(ponto);
  }
  for (var ponto in pontos.reversed) {
    pontosReversos.add(retiraDataPonto(ponto));
  }
  int qtdPontos = await buscaDiasPonto();
  mapRetorno.addAll({"qtdPontos": qtdPontos, "Pontos": pontosReversos});

  return mapRetorno;
}

retiraDataPonto(Ponto ponto) {
  var entrada;
  var saida;
  if (ponto.entrada1 != null) {
    entrada = ponto.entrada1.split("T");
    ponto.entrada1 = entrada[1];
    entrada = "";
  }
  if (ponto.entrada2 != null) {
    entrada = ponto.entrada2.split("T");
    ponto.entrada2 = entrada[1];
    entrada = "";
  }
  if (ponto.entrada3 != null) {
    entrada = ponto.entrada3.split("T");
    ponto.entrada3 = entrada[1];
    entrada = "";
  }
  if (ponto.saida1 != null) {
    saida = ponto.saida1.split("T");
    ponto.saida1 = saida[1];
    saida = "";
  }
  if (ponto.saida2 != null) {
    saida = ponto.saida2.split("T");
    ponto.saida2 = saida[1];
    saida = "";
  }
  if (ponto.saida3 != null) {
    saida = ponto.saida3.split("T");
    ponto.saida3 = saida[1];
    saida = "";
  }
  return ponto;
}

buscaDiasPonto() async {
  // funcao verifica os dias que ele precisa bater o ponto
  int qtdPontos = 0;
  var jornada = await getJornada();
  Map dia = jornada[0];
  String entrada1 = dia["entrada1"];
  String entrada2 = dia["entrada2"];
  String entrada3 = dia["entrada3"];
  if (entrada1 != null) qtdPontos = qtdPontos + 1;
  if (entrada2 != null) qtdPontos = qtdPontos + 1;
  if (entrada3 != null) qtdPontos = qtdPontos + 1;
  return qtdPontos;
}

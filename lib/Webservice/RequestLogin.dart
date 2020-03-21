import 'package:controle_ponto/Funcoes/FuncoesLogin.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// nesse documento estará todas as requisiçoes relacionadas ao acesso de login;
// exemplo -> validação de primeiro acesso,alterar senha,alterar senha com user logado,
// login normal

Dio dio = Dio();
String baseUrl = "http://177.19.159.202:8080/ikponto";
//String baseUrl = "https://ikponto.com.br";

Future firstAcessLogin(String login, String codigoValidacao) async {
  Response response;
  dio.options.connectTimeout =
      5000; //seta o valor maximo de 5 segundos de espera,caso ultrapasse da timeout
  response = await dio.post(baseUrl + "/servico/login/validar-codigo", data: {
    "codigoAlterarSenha": codigoValidacao,
    "login": login,
    "numeroSerieCelular": deviceID
  });
  return response.data;
}

Future updatePasswordFirstAcess(String login, String codigoValidacao,
    String senha, String repetirSenha) async {
  Response response;
  dio.options.connectTimeout = 5000;
  response = await dio.post(baseUrl + "/servico/login/alterar-senha", data: {
    "codigoAlterarSenha": codigoValidacao,
    "login": login,
    "senha": senha,
    "repetirSenha": repetirSenha,
  });
  return response.data;
}

Future login(String login, String senha) async {
  Response response;
  dio.options.connectTimeout = 5000;
  response = await dio.post(baseUrl + "/servico/login/autenticar",
      data: {"login": login, "senha": senha, "numeroSerieCelular": deviceID});
  return response.data;
}

int funcaoExecutada;
Future<Map<String, dynamic>> buscaUltimoUsuarioLogado() async {
  print("passou pelo buscaUltimoUsuarioLogado");

  //valida se essa função ja foi executada alguma vez
  if (funcaoExecutada == null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    funcaoExecutada = 1;
    //valida se existe o campo conectado para inserir no checkbox

    //valida se realmente existe esse campo, validação utilizada só por garantia
    if (prefs.containsKey("login")) {
      return {"login": prefs.getString("login"), "executada": funcaoExecutada};
    } else {
      return {"login": "", "executada": funcaoExecutada};
    }
    //retorna caso a função ja tenha sido executada uma vez, poupando recursos do smartphone
  } else {
    return {"executada": funcaoExecutada};
  }
}

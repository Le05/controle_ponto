import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/models/MarcarPontoModel.dart';
import 'package:controle_ponto/models/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();
String baseUrl = "http://177.19.159.202:8080/ikponto";
//String baseUrl = "https://ikponto.com.br";
Helpers helpers = Helpers();

Future marcacaoPonto(MarcaPonto marcaPonto, String idPont,
    String zerosSequencia, endereco) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User dadosUser = await helpers.getUser(int.parse(prefs.getString("id")));
  Response response;

  String localizacaoEndereco = endereco[0].thoroughfare +", "+
      endereco[0].subThoroughfare +", "+
      endereco[0].subAdministrativeArea +", "+
      endereco[0].administrativeArea;
  print(localizacaoEndereco);
  dio.options.connectTimeout = 5000;
  dio.options.headers = {
    'Authorization': 'Bearer ' + prefs.getString("key"),
    'idFuncionario': prefs.getString("id")
  };
  response = await dio.post("$baseUrl/servico/sessao/ponto/marcar", data: {
    "id": prefs.getString("id"),
    "grupo": prefs.getString("grupo"),
    "dataInicio": marcaPonto.dataPontos,
    "dataFinal": marcaPonto.dataPontos,
    "cnpj": dadosUser.cnpjUser,
    "coletas": [
      {
        "pis": dadosUser.pisUser,
        "dias": [
          {
            "dia": marcaPonto.dataPontos,
            "marcacoes": [
              {
                "dia": marcaPonto.dataPontos,
                "dataHora": marcaPonto.dataPontos + " " + marcaPonto.horaPontos,
                "sequencia": zerosSequencia + marcaPonto.sequenciaPontos,
                "numeroSerie": dadosUser.numSerieUser,
                "pis": dadosUser.pisUser,
                "numCnpj": dadosUser.cnpjUser,
                "fonte": "I",
                "externa": true,
                "latitude": marcaPonto.latitudePontos,
                "longitude": marcaPonto.longitudePontos,
                "registroMobile": idPont,
                "local": localizacaoEndereco
              }
            ]
          }
        ]
      }
    ]
  });

  return response.data;
}

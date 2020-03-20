import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/models/MarcarPontoModel.dart';
import 'package:controle_ponto/models/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();
//String baseUrl = "http://201.23.232.153:8080/ikponto";
String baseUrl = "https://ikponto.com.br";

Helpers helpers = Helpers();

Future sincronizar() async {
 // List dataSeparadas = List();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<MarcaPonto> marcaPonto = await helpers.getAlPontosNotSync();
  User user = await helpers.getUser(int.parse(prefs.getString("id")));
  
  String ultimaData;
  List pont = List();
  Map<String, dynamic> pontoJson;
  List sincronizado = List();

  /*for (var data in marcaPonto) {
    dataSeparadas.add(data.dataPontos);
  }*/
  for (var dat in marcaPonto) {
    pont.clear();
    if (dat.dataPontos != ultimaData) {
      for (var pontos in marcaPonto) {
        if (dat.dataPontos == pontos.dataPontos) {
          //criando o json para inserir na requisição separadamente
          pontoJson = {
            "dia": pontos.dataPontos.toString(),
            "dataHora": pontos.dataPontos.toString() + " " + pontos.horaPontos.toString(),
            "sequencia": contaZerosSequencia(pontos.sequenciaPontos).toString()+pontos.sequenciaPontos.toString(),
            "numeroSerie": user.numSerieUser.toString(),
            "pis": user.pisUser.toString(),
            "numCnpj": user.cnpjUser.toString(),
            "fonte": "I"
          };
          sincronizado.add(pontos.idPontos);
          pont.add(pontoJson);
        }
      }
      print("enviou o dia $pont");
      dio.options.connectTimeout = 5000;
      dio.options.headers = {
        'Authorization': 'Bearer ' + prefs.getString("key"),
        'idFuncionario': prefs.getString("id")
      };
      await dio.post("$baseUrl/servico/sessao/ponto/processar-marcacoes", data: {

    "id": prefs.getString("id"),
		"grupo":prefs.getString("grupo"),
    "dataInicio": dat.dataPontos,
    "dataFinal": dat.dataPontos,
    "cnpj": user.cnpjUser,
    "coletas": [
      {
				"pis":user.pisUser,
        "dias": [
					{
						"dia":dat.dataPontos,
						"marcacoes":pont  // dentro do pont, ja tem as [] e as {}, por conta disso, nao precisa colocar
					}
				]
      }
    ]
      }).then((onValue) async {
        // pega os ids dos pontos que foram sincronizados(id do ponto no banco)
        for (var sinc in sincronizado) {
          await helpers.updateSync(sinc);
        }
      }).catchError((onError) {
        print(onError);
      });
    }
    sincronizado.clear();
    ultimaData = dat.dataPontos;
  }
}

contaZerosSequencia(String sequencia){
  String zeros = "0";
  var tamanhoSequencia = sequencia.toString();
  for (var i = 0; i < 8 - tamanhoSequencia.length; i++) {
    zeros = zeros+"0";
  }
  return zeros;
}

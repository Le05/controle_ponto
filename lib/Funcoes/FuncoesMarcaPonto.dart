import 'package:controle_ponto/HelpersBanco/Helpers.dart';
import 'package:controle_ponto/models/MarcarPontoModel.dart';

Future<List> verificaUltimoPonto(String id,String data) async {
  Helpers helpers = Helpers();
  List<MarcaPonto> marcaPonto = List<MarcaPonto>();
  List pontoSequencia = [];
  int ponto = 0;
  int sequencia = 0;
  int idPont = 0;
  //marcaPonto = await helpers.getPontoDiaAtual(id,data);
  //if(marcaPonto.isEmpty){
    // traz os pontos ja feitos pelo usuario logado
    marcaPonto = await helpers.getPontoGeral(id);
  //}

  for (var item in marcaPonto) {
    //valida se a sequencia obtida do banco é maior que a já existente
    //item.sequenciaPontos = item.sequenciaPontos.replaceAll("0", "");
    if(int.parse(item.sequenciaPontos) >= sequencia)
    {
      sequencia = int.parse(item.sequenciaPontos)+1;
      idPont = int.parse(item.idPontos);
      ponto = int.parse(item.numeroPontos);
    }
  }

  String zeros = "0";
  var tamanhoSequencia = sequencia.toString();
  for (var i = 0; i < 8 - tamanhoSequencia.length; i++) {
    zeros = zeros+"0";
  }
  pontoSequencia.add(ponto+1);//[0]
  pontoSequencia.add(sequencia);//[1]
  pontoSequencia.add(idPont+1);//[2]
  pontoSequencia.add(zeros);//[3]
  return pontoSequencia;
}




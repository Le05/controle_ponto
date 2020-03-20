class MarcaPonto {

//classe utilizada para modelar os dados para o save no banco
String idPontos;
String id_userPontos;
String dataPontos;
String horaPontos;
String numeroPontos;
String sequenciaPontos;
String latitudePontos;
String longitudePontos;
String sincronizadoPontos;

MarcaPonto();

// transforma o mapa vindo do sqflite para um modo utilizavel
  MarcaPonto.fromMap(Map map) {
    idPontos = map["id"].toString();
    id_userPontos = map["id_user"].toString();
    dataPontos = map["data"];
    horaPontos = map["hora"];
    numeroPontos = map["numero_ponto"].toString();
    sequenciaPontos = map["sequencia"].toString();
    latitudePontos = map["latitude"];
    longitudePontos = map["longitude"];
    sincronizadoPontos = map["sincronizado"];
  }

 // converte os dados para mapa, para posteriormente utilizar para
  // gravar no banco
  Map toMap() {
    Map<String, dynamic> map = {
      "id":idPontos,
      "id_user": id_userPontos,
      "data": dataPontos,
      "hora": horaPontos,
      "numero_ponto": numeroPontos,
      "sequencia": sequenciaPontos,
      "latitude": latitudePontos,
      "longitude": longitudePontos,
      "sincronizado": sincronizadoPontos
    };
    if (idPontos != null) {
      map["id"] = idPontos;
    }
    return map;
  }
}
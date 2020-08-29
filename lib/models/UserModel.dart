

class User {
  String idUser;
  String idUserUser;
  String loginUser;
  String senhaUser;
  String nomeUser;
  String tokenUser;
  String adminUser;
  String foto64User;
  String expireToken;
  String cnpjUser;
  String pisUser;
  String numSerieUser;
  String grupoUser;

  User();

// transforma o mapa vindo do sqflite para um modo utilizavel
  User.fromMap(Map map) {
    idUser = map["id"].toString();
    idUserUser = map["id_user"].toString();
    loginUser = map["login"];
    senhaUser = map["senha"];
    nomeUser = map["nome"];
    tokenUser = map["token"];
    expireToken = map["expiretoken"];
    adminUser = map["admin"];
    foto64User = map["foto64"];
    cnpjUser = map["cnpj"];
    pisUser = map["pis"].toString();
    numSerieUser = map["numSerie"];
    grupoUser = map["grupo"];
  }

  // converte os dados para mapa, para posteriormente utilizar para
  // gravar no banco
  Map toMap() {
    Map<String, dynamic> map = {
      "id": idUser,
      "id_user": idUserUser,
      "login": loginUser,
      "senha": senhaUser,
      "nome": nomeUser,
      "token": tokenUser,
      "expiretoken": expireToken,
      "admin": adminUser,
      "foto64": foto64User,
      "cnpj": cnpjUser,
      "pis": pisUser,
      "numSerie": numSerieUser,
      "grupo":grupoUser
    };
    if (idUser != null) {
      map["id"] = idUser;
    }
    return map;
  }
}

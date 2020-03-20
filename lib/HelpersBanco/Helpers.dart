import 'package:controle_ponto/models/MarcarPontoModel.dart';
import 'package:controle_ponto/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Nomes as tabelas(foram colocadas dentro de variaveis, visando evitar de errar nos nomes das mesmas)

final String tabelaUsuarios = "usuarios";
final String tabelaPontos = "pontos";

// campos referentes a tabela de usuarios
final String idUser = "id";
final String id_userUser = "id_user";
final String loginUser = "login";
final String senhaUser = "senha";
final String nomeUser = "nome";
final String tokenUser = "token";
final String expireTokenUser = "expiretoken";
final String adminUser = "admin";
final String foto64User = "foto64";
final String cnpjUser = "cnpj";
final String pisUser = "pis";
final String numSerieUser = "numSerie";
final String grupoUser = "grupo";

// campos referentes a tabela de pontos
final String idPontos = "id";
final String id_userPontos = "id_user";
final String dataPontos = "data";
final String horaPontos = "hora";
final String numeroPontos = "numero_ponto";
final String sequenciaPontos = "sequencia";
final String latitudePontos = "latitude";
final String longitudePontos = "longitude";
final String sincronizadoPontos = "sincronizado";

class Helpers {
  static final Helpers _instance = Helpers.internal();

  factory Helpers() => _instance;

  Helpers.internal();

  Database _db;

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "IKPONTO.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tabelaUsuarios($idUser INTEGER PRIMARY KEY,$id_userUser INTEGER,$loginUser TEXT,$senhaUser TEXT, $nomeUser TEXT,$tokenUser TEXT"
          ",$expireTokenUser TEXT, $adminUser INTEGER,$foto64User TEXT,$cnpjUser TEXT, $pisUser INTEGER, $numSerieUser TEXT, $grupoUser TEXT)");
      await db.execute(
          "CREATE TABLE $tabelaPontos($idPontos INTEGER PRIMARY KEY,$id_userPontos INTEGER,$dataPontos TEXT"
          ",$horaPontos TEXT,$numeroPontos INTEGER, $sequenciaPontos INTEGER, $latitudePontos TEXT, $longitudePontos TEXT, $sincronizadoPontos TEXT)");
    });
  }

  Future<MarcaPonto> savePonto(MarcaPonto marcaPonto) async {
    Database dbIkponto = await db;
    var id = await dbIkponto.insert(tabelaPontos, marcaPonto.toMap());
    marcaPonto.idPontos = id.toString();
    return marcaPonto;
  }

  Future<User> getUserLogin(String login, String senha) async {
    Database dbIkponto = await db;
    List<Map> maps = await dbIkponto.query(tabelaUsuarios,
        columns: [
          idUser,
          id_userUser,
          //nomeUser,
          tokenUser,
          expireTokenUser,
          grupoUser
          //adminUser,
          //foto64User,
          //cnpjUser,
          //pisUser,
          //numSerieUser,
        ],
        where: "$loginUser = ? AND  $senhaUser = ?",
        whereArgs: [login,senha]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future getPontoDiaAtual(String id, String dataAtual) async {
    Database dbIkponto = await db;
    List listMap = await dbIkponto.rawQuery(
        "SELECT * FROM $tabelaPontos WHERE $id_userPontos = $id and $dataPontos = '$dataAtual' order by $dataPontos DESC");
    List<MarcaPonto> listPontos = List();
    for (Map m in listMap) {
      listPontos.add(MarcaPonto.fromMap(m));
    }
    return listPontos;
  }

  Future<List> getPontoGeral(String id) async {
    Database dbIkponto = await db;
    List listMap = await dbIkponto.rawQuery(
        "SELECT * FROM $tabelaPontos WHERE $id_userPontos = $id order by $sequenciaPontos DESC");
    List<MarcaPonto> listPontos = List();
    for (Map m in listMap) {
      listPontos.add(MarcaPonto.fromMap(m));
    }
    return listPontos;
  }

  Future<User> saveUser(User user) async {
    Database dbIkponto = await db;
    var id = await dbIkponto.insert(tabelaUsuarios, user.toMap());
    user.idUser = id.toString();
    return user;
  }

  Future updateKeyUser(String expiretoken, String token, String id) async {
    Database dbIkponto = await db;
    Map<String, dynamic> dadosKey = {
      "$tokenUser": token,
      "$expireTokenUser": expiretoken
    };
    List<Map> maps = await dbIkponto.query(tabelaUsuarios,
        columns: [id_userUser, tokenUser],
        where: "$id_userUser = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return await dbIkponto.update(tabelaUsuarios, dadosKey,
          where: "$id_userUser = ?", whereArgs: [id]);
    } // else {
    //return null;
    //}
  }

  Future<int> updateFoto64(String foto, String id) async {
    Map<String, dynamic> foto64 = {"foto64": foto};
    Database dbIkponto = await db;
    return await dbIkponto.update(tabelaUsuarios, foto64,
        where: "$id_userUser = ?", whereArgs: [id]);
  }

  Future<int> updateSync(String id) async {
    Map<String, dynamic> user = {"$sincronizadoPontos": "true"};
    Database dbIkponto = await db;
    return await dbIkponto
        .update(tabelaPontos, user, where: "$idPontos = ?", whereArgs: [id]);
  }

  Future<User> getUserKey(int id) async {
    Database dbIkponto = await db;
    List<Map> maps = await dbIkponto.query(tabelaUsuarios,
        columns: [id_userUser, tokenUser],
        where: "$id_userUser = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User> getUser(int id) async {
    Database dbIkponto = await db;
    List<Map> maps = await dbIkponto.query(tabelaUsuarios,
        columns: [
          //idUser,
          id_userUser,
          nomeUser,
          //tokenUser,
          //expireTokenUser,
          //adminUser,
          //foto64User,
          cnpjUser,
          pisUser,
          numSerieUser,
          grupoUser
        ],
        where: "$id_userUser = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

    Future<User> getUserForMarcaPonto(int id) async {
    Database dbIkponto = await db;
    List<Map> maps = await dbIkponto.query(tabelaUsuarios,
        columns: [
          //idUser,
          id_userUser,
          //nomeUser,
          //tokenUser,
          //expireTokenUser,
          //adminUser,
          foto64User,
          //cnpjUser,
          //pisUser,
          //numSerieUser,
          //grupoUser
        ],
        where: "$id_userUser = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
  Future<List> getAllPontos() async {
    Database dbIkponto = await db;
    List listMap = await dbIkponto
        .rawQuery("SELECT $id_userPontos FROM $tabelaPontos order by hora ASC");
    List<MarcaPonto> listPontos = List();
    for (Map m in listMap) {
      listPontos.add(MarcaPonto.fromMap(m));
    }
    return listPontos;
  }

  Future<List<MarcaPonto>> getAllPontosNotSync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = int.parse(prefs.getString("id"));
    Database dbIkponto = await db;
    List listMap = await dbIkponto.rawQuery(
        "SELECT * FROM $tabelaPontos WHERE $id_userPontos = $id and $sincronizadoPontos = 'false' order by $sequenciaPontos ASC");
    List<MarcaPonto> listPontos = List();
    for (Map m in listMap) {
      listPontos.add(MarcaPonto.fromMap(m));
    }
    return listPontos;
  }

  Future<List<MarcaPonto>> getAlPontosNotSync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = int.parse(prefs.getString("id"));
    Database dbIkponto = await db;
    List listMap = await dbIkponto.rawQuery(
        "SELECT * FROM $tabelaPontos WHERE $id_userPontos = $id and $sincronizadoPontos = 'false' order by $dataPontos ASC");
    List<MarcaPonto> listPontos = List();
    for (Map m in listMap) {
      listPontos.add(MarcaPonto.fromMap(m));
    }
    return listPontos;
  }

  Future closeDb() async {
    Database dbIkponto = await db;
    dbIkponto.close();
  }
}

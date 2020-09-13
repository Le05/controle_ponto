import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Dio dio = Dio();
String base =
    "https://ikreconhecimentofacial.cognitiveservices.azure.com/face/v1.0/";
String chave1 = "322dba385c1c4a03bbef399ef13e5ace";
String chave2 = "5034a7cdfb6f453f9ef13edc5f2b78e3";

Future reconhecimentoFacial(File fotoInterna, fotoTirada) async {
  var faceIdInterna, faceIdTirada;

  Response response;
  dio.clear();
  dio.options.headers = {
    'Ocp-Apim-Subscription-Key': chave1
  };

  dio.options.contentType = "application/octet-stream";
 
  response = await dio.post(base + "detect", data: fotoInterna.openRead());
  faceIdInterna = response.data[0]["faceId"];

// fim da validação da face interna
  response = await dio.post(base + "detect", data: fotoTirada.openRead());
  faceIdTirada = response.data[0]["faceId"];
// fim da tirada

  dio.clear();
//dio.options.contentType =;
  dio.options.headers = {
    'Ocp-Apim-Subscription-Key': chave1
  };
  response = await dio.post(base + "verify",
      data: {"faceId1": faceIdInterna, "faceId2": faceIdTirada});

  return response.data["confidence"];
}

Future createFileFromString(String encodedStr) async {
  Uint8List bytes = base64.decode(encodedStr);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file =
      File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
  await file.writeAsBytes(bytes);
  return file;
}

Future<String> facedetect(File foto) async {
  Response response;
  dio.options.headers = {
    'Ocp-Apim-Subscription-Key': chave1
  };
  
  dio.options.contentType = "application/octet-stream";
  response = await dio.post(base + "detect", data: foto.openRead());
  return response.data[0]["faceId"];
}

verifyFace(String faceIdLocal, String faceIdInst) async {
  Response response;
  dio.options.headers = {
    'Ocp-Apim-Subscription-Key': chave1
  };
  response = await dio.post(base + "verify",
      data: {"faceId1": faceIdLocal, "faceId2": faceIdInst});
  print(response.data);

  return response.data["confidence"];
}

verificaConexao() async {
  dio.clear();
  Response response;
  response = await dio.get("http://www.google.com");
  return response;
}

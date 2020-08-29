import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Dio dio = Dio();

Future reconhecimentoFacial(File fotoInterna,fotoTirada) async {
var faceIdInterna,faceIdTirada;
String base = "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/";
Response response;
dio.options.contentType = "application/octet-stream";
dio.options.headers = {
    'Ocp-Apim-Subscription-Key': '6c7b564b75dc4d0298042e0227c9462d'
  };
response = await dio.post(base+"detect",data: fotoInterna.openRead());
faceIdInterna = response.data[0]["faceId"];

// fim da validação da face interna
response = await dio.post(base+"detect",data: fotoTirada.openRead());
faceIdTirada = response.data[0]["faceId"];
// fim da tirada
dio.clear();
//dio.options.contentType =;
dio.options.headers = {
    'Ocp-Apim-Subscription-Key': '6c7b564b75dc4d0298042e0227c9462d'
  };
response = await dio.post(base+"verify",data:{
  "faceId1":faceIdInterna,
  "faceId2":faceIdTirada
});

return response.data["confidence"];

}

Future createFileFromString(String encodedStr) async {
Uint8List bytes = base64.decode(encodedStr);
String dir = (await getApplicationDocumentsDirectory()).path;
File file = File(
    "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
await file.writeAsBytes(bytes);
return file;
}

Future<String> facedetect(File foto) async {
String base = "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/";
Response response;
dio.options.contentType = "application/octet-stream";
dio.options.headers = {
    'Ocp-Apim-Subscription-Key': '029a56926fce4d85a4691a95643a4f0e'
  };
response = await dio.post(base+"detect",data: foto.openRead());
return response.data[0]["faceId"];

}

verifyFace(String faceIdLocal,String faceIdInst) async{
String base = "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/";
Response response;
//dio.options.contentType = ContentType.json;
dio.options.headers = {
    'Ocp-Apim-Subscription-Key': '029a56926fce4d85a4691a95643a4f0e'
  };
response = await dio.post(base+"verify",data:{
  "faceId1":faceIdLocal,
  "faceId2":faceIdInst
});
print(response.data);

return response.data["confidence"];

}

verificaConexao() async {
  dio.clear();
  Response response;
  response = await dio.get("http://www.google.com");
  return response;
}
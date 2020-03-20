import 'package:controle_ponto/screens/Login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IKPonto App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login()); //Opcoes());
  }
}

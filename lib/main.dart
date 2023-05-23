import 'package:flutter/material.dart';
import 'package:flutter_sayuria/home_page.dart';
import 'package:flutter_sayuria/login.dart';
import 'package:flutter_sayuria/register.dart';

import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => login(),
        '/register': (context) => register(),
      },
    );
  }
}
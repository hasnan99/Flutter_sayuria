import 'dart:convert';
import 'dart:math';

import 'package:flutter_sayuria/home_page.dart';
import 'package:flutter_sayuria/main_page.dart';
import 'package:flutter_sayuria/service/auth_services.dart';
import 'package:flutter_sayuria/service/global.dart';
import 'package:flutter_sayuria/widget/custom.dart';
import 'package:flutter_sayuria/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sayuria/widget/rounded_button.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _login createState() => _login();
}

class _login extends State<login> {
  String identifier='';
  String password='';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Transform.rotate(
                  angle: -pi / 3.5,
                  child: ClipPath(
                    clipper: ClipPainter(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff7CC644),
                            Color(0xff7CC644),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                           ),
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                Text(
                                  "Username or Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  onChanged: (value){
                                    identifier=value;
                                  },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  onChanged: (value){
                                    password=value;
                                  },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: RoundedButton(
                            btnText: 'Login',
                            onBtnPressed: ()=>login_akun(),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .055),
                      InkResponse(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const register()));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Belum Punya Akun ?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(

                                'Daftar',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  login_akun() async{
    if (identifier.isNotEmpty && password.isNotEmpty) {
      http.Response response = await authservice.login(identifier, password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('id', responseMap['user']['id']);
        preferences.setString('nama_depan', responseMap['user']['nama_depan']);
        preferences.setString('nama_belakang', responseMap['user']['nama_belakang']);
        preferences.setString('username', responseMap['user']['username']);
        preferences.setString('email', responseMap['user']['email']);
        preferences.setString('alamat', responseMap['user']['alamat']);
        preferences.setString('profile', responseMap['user']['profile']);
        preferences.setString('token', responseMap['token']);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MainPage(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }
}

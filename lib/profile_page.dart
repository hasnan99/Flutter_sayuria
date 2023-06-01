import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sayuria/login.dart';
import 'package:flutter_sayuria/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';
import 'main_page.dart';

class profilepage extends StatefulWidget {
  @override
  _profilepage createState() => _profilepage();
}

class _profilepage extends State<profilepage> {
  Map<String, dynamic> user = {};

  Future<void> fetchuser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('http://192.168.1.2:8000/api/user/${preferences.getInt('id')}'));
    if (response.statusCode == 200 && response.body != null) {
      setState(() {
        user = json.decode(response.body);
      });
    }
  }

  late SharedPreferences preferences;
  bool isloading=false;
  bool isLoggedIn = false;

  @override
  void initState(){
    super.initState();
    getuserdata();
    fetchuser();
  }

  void getuserdata()async{
    setState(() {
      isloading=true;
    });
    preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      isLoggedIn = true;
    }
    setState(() {
      isloading=false;
    });
  }

  void logout(){
    preferences.clear();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=>MainPage(),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(45.0),
                child: Center(
                  child: SizedBox(height: 120,width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/'+(user['profile']??'').toString(),),
                      )
                    ],
                  ),
                  ),
                ),
              ),
              Text(user['username'] ?? '',style: TextStyle(fontSize:20 ),),
              Text(user['email'] ?? '',style: TextStyle(fontSize:20 ),),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xffD6D6D6),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: (){Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.supervised_user_circle ,color: Colors.black,),
                      SizedBox(width: 20,),
                      Expanded(child: Text("Edit Profile",style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios, color: Color(0xff7CC644)
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xffD6D6D6),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: (){
                    logout();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout ,color: Colors.black,),
                      SizedBox(width: 20,),
                      Expanded(child: Text('Logout',style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios,color: Color(0xff7CC644)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return LoginScreen();
    }
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => login()),
                  );
                },
                icon: const Icon(Icons.login, color: Colors.black),
                label: const Text("Login"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300,50),
                  primary: Color(0xff7CC644)
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => register()),
                  );
                },
                icon: const Icon(Icons.app_registration, color: Colors.black),
                label: const Text("Register"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  primary: Color(0xff7CC644)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


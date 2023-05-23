import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_sayuria/main_page.dart';
import 'package:flutter_sayuria/profile_page.dart';
import 'package:flutter_sayuria/service/auth_services.dart';
import 'package:flutter_sayuria/service/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class edit_profile extends StatefulWidget{
  @override
  _edit_profile createState()=> _edit_profile();
}

class _edit_profile extends State<edit_profile>{

  final TextEditingController idcontrol = TextEditingController();
  TextEditingController nama_depancontroller = new TextEditingController();
  TextEditingController nama_belakangcontroller = new TextEditingController();
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController alamatcontroller = new TextEditingController();


  @override
  void dispose(){
    idcontrol.dispose();
    nama_depancontroller.dispose();
    nama_belakangcontroller.dispose();
    usernamecontroller.dispose();
    emailcontroller.dispose();
    alamatcontroller.dispose();
    super.dispose();
  }

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
    idcontrol.text =(preferences.getInt('id')?? '').toString() ;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
          color: Color(0xff7CC644),
        ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16,top:25,right: 16),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text("Edit Profile",style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130 ,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0,10)
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/'+(user['profile']??'').toString(),),
                        )
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            color: Color(0xff7CC644),
                          ),
                          child: Icon(Icons.edit,color: Colors.white,),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height:35 ,
              ),
              buildTextField("Nama Depan",user['nama_depan'] ?? '',nama_depancontroller),
              buildTextField("Nama Belakang",user['nama_belakang'] ?? '',nama_belakangcontroller),
              buildTextField("Username",user['username'] ?? '',usernamecontroller),
              buildTextField("Email",user['email'] ?? '',emailcontroller),
              buildTextField("Alamat",user['alamat'] ?? '',alamatcontroller),
              SizedBox(
                height: 35,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: ()=> edit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff7CC644),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text("Simpan",style: TextStyle(
                          fontSize: 14,letterSpacing: 2.2,color: Colors.white
                        ),)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText,String placeholder, baru) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: baru,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3 ),
                  labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    fontSize: 16,fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),
    );
  }

  edit()async {
    int? id =int.tryParse(idcontrol.text.toString());
    String nama_depan=nama_depancontroller.text.toString();
    String nama_belakang=nama_belakangcontroller.text.toString();
    String username=usernamecontroller.text.toString();
    String email=emailcontroller.text.toString();
    String alamat=alamatcontroller.text.toString();
    http.Response response=await authservice.ubahprofile(id!, nama_depan, nama_belakang, email, username, alamat);
    Map responsemap=jsonDecode(response.body);
      if(response.statusCode==200){
        errorSnackBar(context, "Profile Berhasil di Update");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainPage(),
            ));
      }else{
        errorSnackBar(context, responsemap.values.first);
      }
  }
}
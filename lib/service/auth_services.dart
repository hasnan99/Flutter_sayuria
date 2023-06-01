
import 'dart:io'as io;
import 'package:flutter_sayuria/model/user.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:flutter_sayuria/service/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

class authservice{
  var token;
  static Future<http.Response> register(
      String nama_depan,String nama_belakang,String username,String email,String password,String konfirmasi_password,) async{
    Map data={
      "nama_depan":nama_depan,
      "nama_belakang":nama_belakang,
      "username":username,
      "email":email,
      "password":password,
      "konfirmasi_password":konfirmasi_password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseurl/auth/register');
    http.Response response =await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> login(String identifier,String password) async{
    Map data={
      "identifier":identifier,
      "password":password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseurl/auth/login');
    http.Response response =await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> ubahprofile(int id,String nama_depan,String nama_belakang,String email, String username,String alamat,io.File profile)async{
    final int userid=id;
    Map data={
      "nama_depan":nama_depan,
      "nama_belakang":nama_belakang,
      "email":email,
      "username":username,
      "alamat":alamat,
    };
    if(profile != null){
      data['profile'] = await profile.readAsBytesSync();
    }
    var body=json.encode(data);
    var url=Uri.parse('$baseurl/profile/$userid');
    http.Response response= await http.put(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> tambahkeranjang(int sayur_id,int user_id,int quantity) async{
    Map data={
      "sayur_id":sayur_id,
      "user_id":user_id,
      "quantity":quantity,
    };
    var body=json.encode(data);
    var url=Uri.parse('$baseurl/keranjang/tambah');
    http.Response response=await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }



}
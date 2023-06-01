import 'package:flutter/material.dart';
import 'package:flutter_sayuria/service/auth_services.dart';
import 'package:flutter_sayuria/service/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class ProductDetailNavbar extends StatefulWidget {
   final int sayurid;
   final int jumlah;
  const ProductDetailNavbar({Key? key, required this.sayurid, required this.jumlah}) : super(key: key);
  @override
  _ProductDetailNavbar createState() => _ProductDetailNavbar();
}

class _ProductDetailNavbar extends State<ProductDetailNavbar> {
  late int? user_id;
  late SharedPreferences preferences;
  bool isloading=false;
  bool isLoggedIn = false;

  @override
  void initState(){
    super.initState();
    getuserdata();
  }

  void getuserdata()async{
    setState(() {
      isloading=true;
    });
    preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      isLoggedIn = true;
      user_id=preferences.getInt('id');
    }
    setState(() {
      isloading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: (){
              if(isLoggedIn){
                tambahkeranjang();
              }else{
                showDialog(
                    context: context,
                    builder:(BuildContext context){
                      return AlertDialog(
                        title: Text('Login terlebih dahulu'),
                        content: Text('Login Untuk menambahkan ke keranjang'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          },
                              child: Text('Login')
                          ),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          },
                              child: Text('Cancel'),
                          )
                        ],
                      );
                    });
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),
            child: const Text(
              'Tambah ke Keranjang',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
          ),
        ),
    );
  }

  tambahkeranjang()async {
    http.Response response = await authservice.tambahkeranjang(widget.sayurid, user_id!, widget.jumlah);
    Map responsemap=jsonDecode(response.body);
    if(response.statusCode==200){
      successSnackBar(context, "Sayur berhasil ditambahkan");
    }else{
      errorSnackBar(context, responsemap.values.first);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String baseurl="http://192.168.1.2:8000/api";
const Map<String,String> headers={"Content-Type":"application/json"};

errorSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));

}

successSnackBar(BuildContext context,String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.lightGreenAccent,
    content: Text(text,style: TextStyle(color: Colors.black),),
    duration: const Duration(seconds: 1),
  ));
}
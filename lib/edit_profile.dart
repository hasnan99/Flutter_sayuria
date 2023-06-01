import 'dart:convert';
import 'dart:io'as io;

import 'package:flutter/material.dart';
import 'package:flutter_sayuria/main_page.dart';
import 'package:flutter_sayuria/profile_page.dart';
import 'package:flutter_sayuria/service/auth_services.dart';
import 'package:flutter_sayuria/service/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late io.File _profile;
  late PickedFile _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    _pickedFile = (await _picker.getImage(source: ImageSource.gallery))!;
    if (_pickedFile.path != null) {
      setState(() {
        _profile = io.File(_pickedFile.path);
      });
    }
  }

  final TextEditingController idControl = TextEditingController();
  TextEditingController namaDepanController = TextEditingController();
  TextEditingController namaBelakangController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  @override
  void dispose() {
    idControl.dispose();
    namaDepanController.dispose();
    namaBelakangController.dispose();
    usernameController.dispose();
    emailController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Map<String, dynamic> user = {};

  Future<void> fetchUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('http://192.168.1.2:8000/api/user/${preferences.getInt('id')}'));
    if (response.statusCode == 200 && response.body != null) {
      setState(() {
        user = json.decode(response.body);
      });
    }
  }

  late SharedPreferences preferences;
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchUser();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      isLoggedIn = true;
    }
    setState(() {
      isLoading = false;
    });
    idControl.text = (preferences.getInt('id') ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff7CC644),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/' + (user['profile'] ?? '').toString()),
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            color: Color(0xff7CC644),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Nama Depan", user['nama_depan'] ?? '', namaDepanController),
              buildTextField("Nama Belakang", user['nama_belakang'] ?? '', namaBelakangController),
              buildTextField("Username", user['username'] ?? '', usernameController),
              buildTextField("Email", user['email'] ?? '', emailController),
              buildTextField("Alamat", user['alamat'] ?? '', alamatController),
              SizedBox(
                height: 35,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => edit(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff7CC644),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        "Simpan",
                        style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                      ),
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

  Widget buildTextField(String labelText, String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Future<void> edit() async {
    int id = int.tryParse(idControl.text.toString())!;
    String namaDepan = namaDepanController.text.toString();
    String namaBelakang = namaBelakangController.text.toString();
    String username = usernameController.text.toString();
    String email = emailController.text.toString();
    String alamat = alamatController.text.toString();

    http.Response response =
    await authservice.ubahprofile(id, namaDepan, namaBelakang, email, username, alamat, _profile);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      errorSnackBar(context, "Profile Berhasil di Update");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MainPage(),
        ),
      );
    } else {
      errorSnackBar(context, responseMap.values.first);
    }
  }
}

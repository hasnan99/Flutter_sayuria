import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sayuria/product_detail_navbar.dart';
import 'package:flutter_sayuria/widget/rupiah.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final int productId;
  const ProductDetail({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Map<String, dynamic> sayur = {};

  Future<void> fetchdetailsayur() async {
    final response = await http.get(Uri.parse('http://192.168.1.2:8000/api/product/${widget.productId}'));
    if (response.statusCode == 200) {
      setState(() {
        sayur = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdetailsayur();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                ),
                const Text(
                  'Detail Produk',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/ic_cart.png',
                  width: 20,
                )
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          header(),
          Image.asset(
            'assets/images/'+(sayur['gambar']??''),
            width: MediaQuery.of(context).size.width,
            height: 315,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    sayur['nama_produk'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10),
                  child:  Text(
                    'Stock : '+ (sayur['stock']?.toString()??''),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '1',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                       Text(
                         CurrencyFormat.convertToIdr(
                           sayur['harga_sayur'] is String ? double.tryParse(sayur['harga_sayur']) ?? 0.0 : sayur['harga_sayur'] ?? 0.0,
                           2,
                         ).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          sayur['deskripsi'] ?? '',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ProductDetailNavbar(),
    );
  }
}

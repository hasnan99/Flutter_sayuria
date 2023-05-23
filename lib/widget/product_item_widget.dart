import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_sayuria/widget/rupiah.dart';
import 'package:flutter_sayuria/model/sayur.dart';

import '../product_detail.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({Key? key}) : super(key: key);

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

Future<List<sayur>> fetchSayur({String? query}) async {
  final response = await http.get(Uri.parse('http://192.168.1.2:8000/api/product'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var parsed = data['data'].cast<Map<String, dynamic>>();

    List<sayur> results = parsed.map<sayur>((json) => sayur.fromJson(json)).toList();

    if (query != null) {
      List<String> keywords = query.split(' ');
      results = results.where((element) {
        for (var keyword in keywords) {
          if (element.nama_sayur.toLowerCase().contains(keyword.toLowerCase())) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    return results;
  } else {
    throw Exception('Failed');
  }
}


class _ProductItemWidgetState extends State<ProductItemWidget> {
  late Future<List<sayur>> Sayur;

  @override
  void initState() {
    super.initState();
    Sayur = fetchSayur();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<sayur>>(
      future: Sayur,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<sayur> products = snapshot.data!;
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 15),
            children: products.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>ProductDetail(productId: product.id,)));
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xffeef1f4),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/${product.gambar}',
                              ),
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          CurrencyFormat.convertToIdr(product.harga_sayur, 2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.nama_sayur,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Stock: ${product.stock}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to fetch products');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
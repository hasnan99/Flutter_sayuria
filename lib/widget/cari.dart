import 'package:flutter/material.dart';
import 'package:flutter_sayuria/widget/product_item_widget.dart';
import 'package:flutter_sayuria/widget/rupiah.dart';

import '../model/sayur.dart';
import '../product_detail.dart';

class carisayur extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.close),
        onPressed: (){
          query="";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back_ios),
      onPressed: (){
      Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<sayur>>(
      future: fetchSayur(query: query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<sayur> products = snapshot.data!;
          return SingleChildScrollView(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 15),
              children: products.map((product) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ProductDetail(productId: product.id,)));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffeef1f4),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            CurrencyFormat.convertToIdr(product.harga_sayur, 2),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.nama_sayur,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Stock: ${product.stock}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to fetch products');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }



  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Cari Sayur'),
    );
  }
}
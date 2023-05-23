import 'package:flutter/material.dart';
import 'package:flutter_sayuria/widget/cari.dart';
import 'package:flutter_sayuria/widget/product_app_bar.dart';
import 'widget/product_app_bar.dart';
import 'widget/product_item_widget.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const ProductAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xffeef1f4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.black,
                        onPressed: () {showSearch(context: context, delegate: carisayur());
                          },
                      ),
                    ],
                  ),
                ),
                ProductItemWidget()
              ],
            )
          ),
        ],
      ),
    );
  }
}

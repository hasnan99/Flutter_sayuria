import 'package:flutter/material.dart';

class ProductAppBar extends StatelessWidget {
  const ProductAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
      child: Row(
        children: const [
          Icon(
            Icons.sort,
            size: 30,
            color: Colors.black,
          ),
          Padding(padding: EdgeInsets.only(left: 15)),
          Text(
              'List Produk',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )
          ),
          Spacer(),
        ],
      ),
    );
  }
}

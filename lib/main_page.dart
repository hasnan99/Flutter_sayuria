import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';
import 'product_page.dart';
import 'order_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

void main() {
  runApp(MainPage());
}
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget cartButton(){
      return FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){

        },
        child: Image.asset('assets/images/ic_cart.png', width: 30,),
      );
    }

    Widget bottomNavBar(){
      return BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/ic_home.png',
                width: 30,
                color: currentIndex == 0? Colors.green : Colors.black,
              ),
              label: 'Beranda'
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/ic_product.png',
                width: 30,
                color: currentIndex == 1? Colors.green : Colors.black,
              ),
              label: 'Produk'
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/ic_order.png',
                width: 30,
                color: currentIndex == 2? Colors.green : Colors.black,
              ),
              label: 'Pesanan'
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/ic_profile.png',
                width: 30,
                color: currentIndex == 3? Colors.green : Colors.black,
              ),
              label: 'Akun'
          ),
        ],
      );
    }

    Widget body(){
      switch (currentIndex){
        case 0:
          return  HomePage();
        case 1:
          return ProductPage();
        case 2:
          return const OrderPage();
        case 3:
          return profilepage();
        default:
          return  HomePage();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: body(),
      ),
      floatingActionButton: cartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavBar(),
    );
  }
}



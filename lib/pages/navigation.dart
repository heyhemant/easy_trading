import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:demo_stock/pages/HomePage.dart';
import 'package:demo_stock/pages/historypage.dart';
import 'package:demo_stock/pages/profilepage.dart';
import 'package:demo_stock/pages/lonepage.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _page = 0;
  final tab = [HomePage(), LonePage(), HistoryPage(), ProfilePage()];
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 50,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.attach_money_sharp, size: 30),
          Icon(Icons.history, size: 30),
          Icon(Icons.account_balance_wallet, size: 30),
        ],
        color: Color(0xFF73AEF5),
        buttonBackgroundColor: Colors.grey,
        backgroundColor: Color(0xFF398AE5),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: tab[_page],
    );
  }
}

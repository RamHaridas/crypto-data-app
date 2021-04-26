import 'package:crypto_786/screens/exchange.dart';
import 'package:crypto_786/screens/last.dart';
import 'package:crypto_786/screens/newChart.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  List<Widget> screens = [Home(), History(), PieChartSample3()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.grey[200],
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.insights, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}

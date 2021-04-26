import 'package:crypto_786/screens/cryptodetails.dart';
import 'package:crypto_786/screens/exchange.dart';
import 'package:crypto_786/screens/homeMain.dart';
import 'package:crypto_786/screens/last.dart';
import 'package:crypto_786/screens/newChart.dart';
import 'package:crypto_786/screens/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'San'),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/exchange': (context) => History(),
        '/last': (context) => PieChartSample3(),
        '/details': (context) => CryptoDetails(),
        '/graph': (context) => BarChartSample1(),
      },
    );
  }
}

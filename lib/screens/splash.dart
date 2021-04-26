import 'dart:convert';
import 'package:crypto_786/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var data;
  void getData() async {
    var res = await http.get(Uri.parse(BASE_URL + '/coins'), headers: {
      "x-rapidapi-key": API_KEY,
      "x-rapidapi-host": "coinranking1.p.rapidapi.com"
    });

    if (res.statusCode == 200) {
      this.data = jsonDecode(res.body);
      //print(data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    new Future.delayed(const Duration(seconds: 4), () {
      //print(data['status']);
      Navigator.pushReplacementNamed(context, '/home', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/crypto.json'),
      ),
    );
  }
}

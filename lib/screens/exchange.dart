import 'dart:convert';
//import 'package:crypto_786/cards/cryptoCard.dart';
import 'package:crypto_786/cards/tempCryptoCard.dart';
import 'package:crypto_786/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
//import 'package:lottie/lottie.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> cryptolist = [];
  List<dynamic> tempcryptolist = [];
  var data;
  //get all coins data
  Future<void> getData() async {
    var res = await http.get(Uri.parse(BASE_URL + '/coins'), headers: {
      "x-rapidapi-key": API_KEY,
      "x-rapidapi-host": "coinranking1.p.rapidapi.com"
    });

    if (res.statusCode == 200) {
      this.data = jsonDecode(res.body);
      setState(() {
        tempcryptolist = data != null ? data['data']['coins'] : null;
        cryptolist = tempcryptolist;
        if (data == null || tempcryptolist == null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Internet access")));
        }
      });
    }
  }

  void setList(data) {
    var date = DateTime.fromMillisecondsSinceEpoch(1330214400000);
    //final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatDate(date, [dd, '-', mm, '-', yyyy]);
    print(formatted);
    setState(() {
      cryptolist = data != null ? data['data']['coins'] : null;
      tempcryptolist = cryptolist;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.data == null) {
      this.data = ModalRoute.of(context).settings.arguments;
      //print(data['status']);
      setList(this.data);
    }
    if (cryptolist == null) {
      getData();
      return RefreshIndicator(
        color: Colors.black,
        onRefresh: getData,
        child: Scaffold(
          backgroundColor: Colors.white10,
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * (4 / 100)),
            child: Text(
              "Graphs",
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
          ),
          Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                itemCount: tempcryptolist.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: FlipAnimation(
                      duration: Duration(milliseconds: 300),
                      // horizontalOffset: 50.0,
                      child: ScaleAnimation(
                          duration: Duration(milliseconds: 300),
                          child: TempCard(cryptolist[index], this.context)),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

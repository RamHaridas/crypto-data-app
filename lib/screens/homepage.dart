import 'dart:convert';
import 'package:crypto_786/cards/cryptoCard.dart';
import 'package:crypto_786/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> cryptolist = [];
  List<dynamic> tempcryptolist = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var data;
  //get all coins data
  Future<void> getData() async {
    var res = await http.get(Uri.parse(BASE_URL + '/coins'));

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
    var date = DateTime.fromMillisecondsSinceEpoch(1618560000000);
    //final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatDate(date, [dd, '-', mm, '-', yyyy]);
    print(formatted);
    setState(() {
      cryptolist = data != null ? data['data']['coins'] : null;
      tempcryptolist = cryptolist;
    });
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (text) {
          text = text.toUpperCase();

          setState(() {
            tempcryptolist = cryptolist.where((element) {
              String name = element['symbol'].toString();

              return name.contains(text);
            }).toList();
          });
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search',
        ),
      ),
    );
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
    return RefreshIndicator(
      onRefresh: getData,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            ClipRect(
              child: Image.asset(
                'assets/icons/dogeBanner.jpg',
                height: 200,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            search(),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                    itemCount: tempcryptolist.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          duration: Duration(milliseconds: 300),
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                              duration: Duration(milliseconds: 300),
                              child:
                                  CrytpoCard(cryptolist[index], this.context)),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

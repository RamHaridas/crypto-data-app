import 'package:crypto_786/screens/cryptodetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class TempCard extends StatefulWidget {
  var data;
  BuildContext context;
  TempCard(this.data, this.context);

  @override
  _CrytpoCardState createState() => _CrytpoCardState(data, context);
}

class _CrytpoCardState extends State<TempCard> {
  var data;
  String curr;
  BuildContext context;
  _CrytpoCardState(this.data, this.context) {
    this.curr = "\$ ${this.data['price'].toString().substring(0, 5)}";
    //print(this.curr);
  }

  @override
  Widget build(BuildContext context) {
    //print(data['iconUrl']);
    return Padding(
      padding: EdgeInsets.all(7),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         settings: RouteSettings(arguments: data),
          //         child: CryptoDetails(),
          //         type: PageTransitionType.scale));

          Navigator.pushNamed(context, '/graph', arguments: data);
        },
        child: Card(
          color: Colors.white,
          elevation: 2.5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Hero(
                  tag: data['name'],
                  child: SvgPicture.network(
                    data['iconUrl'],
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data['symbol'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(this.curr,
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold, color: Colors.green))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

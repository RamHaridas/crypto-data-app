import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto_786/screens/generatorUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoDetails extends StatefulWidget {
  @override
  _CryptoDetailsState createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  var data;
  List<dynamic> list = [];

  void setList(list) {
    setState(() {
      this.list = list;
    });
  }

  Future<void> _launchInBrowser() async {
    if (await canLaunch(data['websiteUrl'])) {
      await launch(
        data['websiteUrl'],
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch ${data['websiteUrl']}';
    }
  }

  void openAlert() {
    Alert(
      context: context,
      title: "PRANK!",
      desc: "You can't buy coin in this app",
      content: Image.asset("assets/icons/django.jpg"),
    ).show();
  }

  Future<void> _launchInMedia(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    setList(data['links']);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/icons/bannerNee.png'))),
              child: Hero(
                tag: data['name'],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: SvgPicture.network(
                      data['iconUrl'],
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              //this is the slimy card that displays the information about crypto
              padding: const EdgeInsets.all(8.0),
              child: SlimyCard(
                color: Colors.blueAccent,
                width: MediaQuery.of(context).size.width,
                topCardHeight: 400,
                bottomCardHeight: 200,
                borderRadius: 15,
                topCardWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'San',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(data['rank'].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 50)),
                      Text("RANK",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      SizedBox(
                        height: 8,
                      ),
                      Text("PRICE: \$${data['price']}",
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      Text("VOLUME: ${data['volume']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      Text("MARKETS: ${data['numberOfMarkets']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      SizedBox(height: 10),
                      Text("Highest price yet",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text("${data['allTimeHigh']['price']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      ElevatedButton(
                        onPressed: openAlert,
                        child: Text("BUY"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepOrange)),
                      ),
                    ],
                  ),
                ),
                bottomCardWidget: Column(
                  children: [
                    Text(
                      "For more information visit",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: _launchInBrowser,
                      child: Text(
                        data['websiteUrl'] != null ? data['websiteUrl'] : "",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    _launchInMedia(list[index]['url']);
                                  },
                                  child: GenerateUI()
                                      .getIcon(list[index]['type'])),
                            );
                          },
                          itemCount: list.length,
                        ),
                      ),
                    )
                  ],
                ),
                slimeEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

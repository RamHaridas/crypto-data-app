import 'dart:convert';
import 'package:crypto_786/constants.dart';
import 'package:crypto_786/screens/generatorUI.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:url_launcher/url_launcher.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
// fab_circular_menu

class PieChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  List<dynamic> cryptolist = [];
  List<dynamic> temp = [];
  static GenerateUI gen = GenerateUI();

  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink
  ];
  int touchedIndex;
  var data;

  Future<void> _launchInMedia() async {
    if (await canLaunch(dogeAPP)) {
      await launch(
        dogeAPP,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $dogeAPP';
    }
  }

  Future<void> _rickRoll() async {
    if (await canLaunch(rick)) {
      await launch(
        rick,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $rick';
    }
  }

  Future<void> getData() async {
    var res = await http.get(Uri.parse(BASE_URL + '/coins'), headers: {
      "x-rapidapi-key": API_KEY,
      "x-rapidapi-host": "coinranking1.p.rapidapi.com"
    });

    if (res.statusCode == 200) {
      this.data = jsonDecode(res.body);
      setState(() {
        cryptolist = data != null ? data['data']['coins'] : null;
        temp = cryptolist.sublist(0, 5);

        if (data == null || cryptolist == null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Internet access")));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void setPriceForChart(index) {
    switch (index) {
      case 1:
        gen.priceForChart = 'numberOfMarkets';
        break;
      case 2:
        gen.priceForChart = 'numberOfExchanges';
        break;
      case 3:
        gen.priceForChart = 'volume';
        break;
      case 4:
        gen.priceForChart = 'marketCap';
        break;
      case 5:
        gen.priceForChart = 'circulatingSupply';
        break;
      default:
        gen.priceForChart = 'volume';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (temp == null || temp.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FabCircularMenu(
        fabOpenIcon: Icon(Icons.tune, color: Colors.white),
        fabCloseIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        fabColor: Colors.deepPurple,
        ringColor: Colors.deepPurpleAccent,
        alignment: Alignment.bottomLeft,
        animationDuration: Duration(milliseconds: 200),
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                setPriceForChart(1);
              });
            },
            child: Text(
              "Market",
              style: GenerateUI().fabTextStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setPriceForChart(2);
              });
            },
            child: Text(
              "Exchange",
              style: GenerateUI().fabTextStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setPriceForChart(3);
              });
            },
            child: Text(
              "Volume",
              style: GenerateUI().fabTextStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setPriceForChart(4);
              });
            },
            child: Text(
              "MarketCap",
              style: GenerateUI().fabTextStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setPriceForChart(5);
              });
            },
            child: Text(
              "Supply",
              style: GenerateUI().fabTextStyle,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * (4 / 100)),
              child: Text(gen.priceForChart,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.deepPurple,
                  )),
            ),
            Text(
              "Top 5 Coins",
              style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                ),
              ),
            ),
            Text("This application was made only to promote Dogecoin"),
            Text(
              "Doge is people's crypto",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: _launchInMedia,
              child: Image.asset(
                'assets/icons/multidoge.png',
                height: 100,
                width: 100,
              ),
            ),
            Text("Please visit below URL to know more about Dogecoin"),
            Text("https://dogecoin.com/"),
            Divider(color: Colors.black),
            GestureDetector(
              onTap: _rickRoll,
              child: Image.asset(
                'assets/icons/elon.png',
                height: 100,
                width: 100,
              ),
            ),
            Text("Click the above icon"),
            Text("Get a chance to meet Elon"),
            Divider(color: Colors.black),
            SizedBox(
              height: 10,
            ),
            Text(
              "This app was made with ❤️ in India",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(temp.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 15;
      final double radius = isTouched ? 110 : 100;
      final double widgetSize = isTouched ? 55 : 40;

      return PieChartSectionData(
        color: colors.elementAt(i),
        value: temp.elementAt(i)[gen.priceForChart].toDouble(),
        title: temp.elementAt(i)['symbol'],
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
        badgeWidget: SvgPicture.network(
          temp.elementAt(i)['iconUrl'],
          width: 40,
          height: 40,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key key,
    @required this.size,
    @required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

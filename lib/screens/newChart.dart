import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../constants.dart';
import 'package:date_format/date_format.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
    Colors.red,
    Colors.cyan
  ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  List<dynamic> list = [];
  List<dynamic> sortedList = [];
  List<int> uniqedays = [];
  var data;
  double maxPrice = 0;
  int touchedIndex;

  bool isPlaying = false;

  void getUniquedays(list) {
    bool exists = false;
    for (var d in list) {
      var date = DateTime.fromMillisecondsSinceEpoch(d['timestamp']);
      if (uniqedays.indexOf(date.day) == -1) {
        uniqedays.add(date.day);

        if (double.parse(d['price']) > maxPrice) {
          maxPrice = double.parse(d['price']);
        }
        sortedList.add(d);
      }
    }
  }

  void getData(id) async {
    var res = await http.get(Uri.parse(BASE_URL + '/coin/$id/history/7d'),
        headers: {
          "x-rapidapi-key": API_KEY,
          "x-rapidapi-host": "coinranking1.p.rapidapi.com"
        });

    if (res.statusCode == 200) {
      this.data = jsonDecode(res.body);

      list = this.data["data"]["history"];
      if (this.mounted) {
        setState(() {
          getUniquedays(list);
          print(sortedList.toString());
        });
      }

      //print(list.elementAt(1));
    } else {
      print("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (data != null) {
      getData(data['id']);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * (5 / 100)),
              child: Hero(
                  tag: data['name'],
                  child: SvgPicture.network(data['iconUrl'],
                      height: 100, width: 100)),
            ),
            SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: const Color(0xff81e5cd),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Price History',
                            style: TextStyle(
                                color: const Color(0xff0f4a3c),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'few days ago',
                            style: TextStyle(
                                color: const Color(0xff379982),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 38,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BarChart(
                                isPlaying ? randomData() : mainBarData(),
                                swapAnimationDuration: animDuration,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: const Color(0xff0f4a3c),
                          ),
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                              if (isPlaying) {
                                refreshState();
                              }
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Visibility(
              visible: isPlaying,
              child: Column(
                children: [
                  Lottie.asset('assets/doge.json',
                      width: MediaQuery.of(context).size.width, height: 300),
                  Text("To the Moon.....", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.orange] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxPrice,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(sortedList.length, (i) {
        String weekDay;
        String price;
        double prc = double.parse(sortedList.elementAt(i)['price']);
        price = "\$${prc.toStringAsFixed(2)}";
        var date = DateTime.fromMillisecondsSinceEpoch(
            sortedList.elementAt(i)['timestamp']);
        //final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted =
            formatDate(date, [dd, '/', mm, '\n', 'HH', ':', 'mm']);
        //print(formatted);
        weekDay = formatted;
        return makeGroupData(date.weekday, prc, isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              String price;
              double prc =
                  double.parse(sortedList.elementAt(group.x.toInt())['price']);
              price = "\$${prc.toStringAsFixed(2)}";
              var date = DateTime.fromMillisecondsSinceEpoch(
                  sortedList.elementAt(group.x.toInt())['timestamp']);
              //final DateFormat formatter = DateFormat('dd-MM-yyyy');
              final String formatted =
                  formatDate(date, [dd, '/', mm, '\n', 'HH', ':', 'mm']);
              //print(formatted);
              weekDay = formatted;
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: price,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            var date = DateTime.fromMillisecondsSinceEpoch(
                sortedList.elementAt(value.toInt())['timestamp']);
            //print(value.toInt());
            return date.day.toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 3,
          getTitles: (double value) {
            var date = DateTime.fromMillisecondsSinceEpoch(
                sortedList.elementAt(value.toInt())['timestamp']);
            return date.day.toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(sortedList.length, (i) {
        String weekDay;
        String price;
        double prc = double.parse(sortedList.elementAt(i)['price']);
        price = "\$${prc.toStringAsFixed(2)}";
        var date = DateTime.fromMillisecondsSinceEpoch(
            sortedList.elementAt(i)['timestamp']);
        //final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted =
            formatDate(date, [dd, '/', mm, '\n', 'HH', ':', 'mm']);
        //print(formatted);
        weekDay = formatted;
        return makeGroupData(
            date.weekday, Random().nextInt(maxPrice.toInt() + 1).toDouble() + 1,
            barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}

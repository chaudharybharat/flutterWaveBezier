import 'package:flutter/material.dart';
import 'package:wave_cubic_flutter/wave_slider.dart';

import 'curved_chart_painter.dart';

void main() => runApp(MaterialApp(
      home: App(),
    ));

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _age = 0;

  final Color? color=Colors.blue;
  final double strokeWidth=2;
  @override
  Widget build(BuildContext context) {

    final List<Map<String, double>> xValues = [
      {"day 1": 10.0},
      {"day 2": 20.0},
      {"day 3": 20.0},
      {"day 4": 25.0},
      {"day 5": 20.0},
      {"day 6": 20.0},
      {"day 7": 100.0},
    ];

    // Define the Y axis values for the chart
    // String will be text label and double will be value in the Map<String, double>
    final List<Map<String, double>> yValues = [
      {"0": 0.0},
      {"20": 50.0},
      {"40": 50.0},
      {"60": 50.0},
      {"80": 50.0},
      {"100": 100.0},
    ];
    return Scaffold(
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(32.0),
          child:CustomPaint(
            size: Size(400, 200),
            painter: CurvedChartPainter(xValues: xValues,
                yValues: yValues,
                strokeWidth: strokeWidth),
          )),
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select your age',
                style: TextStyle(
                  fontSize: 45,
                  fontFamily: 'Exo',
                ),
              ),
              WaveSlider(
                onChanged: (double val) {
                  setState(() {
                    _age = (val * 100).round();
                  });
                },
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  SizedBox(width: 20.0),
                  Text(
                    _age.toString(),
                    style: TextStyle(fontSize: 45.0),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'YEARS',
                    style: TextStyle(fontFamily: 'TextMeOne', fontSize: 20.0),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              )
            ],
          ),
        )
      ],),
    );
  }
}

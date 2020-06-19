import 'package:OpenSky/model/Daily.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DailyWidgetTemp extends StatelessWidget {
  final Daily forecast;
  final String field;
  final double minDailyTemp, maxDailyTemp;

  DailyWidgetTemp(
      {Key key,
      this.forecast,
      this.field,
      this.minDailyTemp,
      this.maxDailyTemp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double minTemp = _getMinFieldValue(forecast, field);
    double maxTemp = _getMaxFieldValue(forecast, field);
    Size minTempWidth = _calculateTextSize('${minTemp.toStringAsFixed(0)}°');
    Size maxTempWidth = _calculateTextSize('${maxTemp.toStringAsFixed(0)}°');
    double width = MediaQuery.of(context).size.width -
        120 -
        minTempWidth.width -
        maxTempWidth.width;

    return Padding(
        padding: EdgeInsets.fromLTRB(2, 3, 0, 3),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                child: SizedBox(
                    width: 55,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            _getDayName(forecast.dt),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 0.9),
                          ),
                        ]))),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                child: Image(
                    image: AssetImage('assets/${forecast.weather[0].icon}.png'),
                    width: 25,
                    height: 25)),
          ]),
          Expanded(
              child: Container(
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  curve: Curves.easeOutCubic,
                  duration: Duration(milliseconds: 800),
                  width: _getTempLeftMargin(context, width, minTemp),
                ),
                AnimatedContainer(
                  curve: Curves.easeOutCubic,
                  duration: Duration(milliseconds: 800),
                  // width: _getTempWidth(context),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                          child: Text(
                            '${minTemp.toStringAsFixed(0)}°',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      AnimatedContainer(
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 800),
                          width:
                              _getTempWidth(context, width, minTemp, maxTemp),
                          height: 14,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 70, 70, 70),
                              borderRadius: BorderRadius.circular(12))),
                      minAndMaxTempsMatch(minTemp, maxTemp)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 5, 0),
                              child: Text(
                                '${maxTemp.toStringAsFixed(0)}°',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ]));
  }

  String _getDayName(DateTime date) {
    var today = new DateTime.now().day;

    if (date.day == today) {
      return 'TODAY';
    } else {
      return new intl.DateFormat('E').format(date).toUpperCase();
    }
  }

  num _getMinFieldValue(Daily forecast, String field) {
    if (field == "temp") {
      return forecast.temp.min;
    } else {
      // "feelsLike"
      return forecast.feelsLike.getMin();
    }
  }

  num _getMaxFieldValue(Daily forecast, String field) {
    if (field == "temp") {
      return forecast.temp.max;
    } else {
      // "feelsLike"
      return forecast.feelsLike.getMax();
    }
  }

  double _getTempWidth(
      BuildContext context, double width, double minTemp, double maxTemp) {
    double tempWidth =
        ((maxTemp - minTemp) / (maxDailyTemp - minDailyTemp)) * width;

    return tempWidth < 14.0 ? 14.0 : tempWidth;
  }

  double _getTempLeftMargin(
      BuildContext context, double width, double minTemp) {
    double leftMargin =
        ((minTemp - minDailyTemp) / (maxDailyTemp - minDailyTemp)) * width;

    return leftMargin;
  }

  Size _calculateTextSize(String text) {
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        maxLines: 1)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  bool minAndMaxTempsMatch(double min, double max) {
    return max - min < 1.0;
  }
}

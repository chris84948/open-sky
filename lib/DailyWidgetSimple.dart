import 'package:OpenSky/ValueWidgets.dart';
import 'package:OpenSky/model/Daily.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyWidgetSimple extends StatelessWidget {
  final Daily forecast;
  final String field;
  final double minDailyValue, maxDailyValue;

  DailyWidgetSimple(
      {Key key,
      this.forecast,
      this.minDailyValue,
      this.maxDailyValue,
      this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Flexible(
            child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                    begin: 0.0,
                    end: _getRelativePosition(_getFieldValue(forecast, field),
                        minDailyValue, maxDailyValue)),
                builder: (_, double leftRelativePos, __) {
                  return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: leftRelativePos,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Container(
                            color: Color.fromARGB(255, 150, 150, 150),
                            height: 1,
                          )));
                }),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: _getValueWidget())))
        ]));
  }

  Widget _getValueWidget() {
    if (field == "uvi") {
      return ValueWidgets.uvIndex(_getFieldTextValue(forecast, field));
    } else if (field == "windSpeed") {
      return ValueWidgets.wind(
          _getFieldTextValue(forecast, field), forecast.windSpeed);
    } else {
      return ValueWidgets.simple(_getFieldTextValue(forecast, field));
    }
  }

  String _getDayName(DateTime date) {
    var today = new DateTime.now().day;

    if (date.day == today) {
      return 'TODAY';
    } else {
      return new DateFormat('E').format(date).toUpperCase();
    }
  }

  _getRelativePosition(val, minVal, maxVal) {
    if ((maxVal - minVal) == 0) {
      return 1.0;
    }

    return ((val - minVal) / (maxVal - minVal));
  }

  num _getFieldValue(Daily forecast, String field) {
    if (field == "pressure") {
      return forecast.pressure.toDouble();
    } else if (field == "humidity") {
      return forecast.humidity.toDouble();
    } else if (field == "clouds") {
      return forecast.clouds.toDouble();
    } else if (field == "dewPoint") {
      return forecast.dewPoint;
    } else if (field == "windSpeed") {
      return forecast.windSpeed;
    } else if (field == "windDir") {
      return forecast.windDeg.toDouble();
    } else if (field == "uvi") {
      return forecast.uvi.roundToDouble();
    } else {
      // "rain"
      return forecast.rain;
    }
  }

  String _getFieldTextValue(Daily forecast, String field) {
    num value = _getFieldValue(forecast, field);

    if (field == "rain") {
      return '${value.toStringAsFixed(2)}"';
    } else if (field == "humidity" || field == "clouds") {
      return '${value.toStringAsFixed(0)}%';
    } else if (field == "dewPoint") {
      return '${value.toStringAsFixed(0)}°';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}

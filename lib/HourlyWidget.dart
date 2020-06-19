import 'package:OpenSky/ValueWidgets.dart';
import 'package:OpenSky/model/Hourly.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:OpenSky/Ext.dart';

class HourlyWidget extends StatelessWidget {
  final Hourly forecast;
  final String field;
  final double minHourlyValue, maxHourlyValue;
  final bool hideDescription;
  HourlyWidget(
      {Key key,
      this.forecast,
      this.field,
      this.minHourlyValue,
      this.maxHourlyValue,
      this.hideDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: <Widget>[
      Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
            child: Image(
                image: AssetImage('assets/${forecast.weather[0].icon}.png'),
                width: 25,
                height: 25)),
        Padding(
            padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
            child: SizedBox(
                width: 41,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        DateFormat('h').format(forecast.dt),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 0.9),
                      ),
                      Text(
                        ' ${DateFormat('a').format(forecast.dt)}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ]))),
        Stack(alignment: AlignmentDirectional.centerStart, children: <Widget>[
          Container(
            color: Color.fromARGB(255, 150, 150, 150),
            width: 135,
            height: 1,
          ),
          this.hideDescription
              ? Container()
              : SizedBox(
                  width: 130,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(forecast.weather[0].description.capitalize(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withOpacity(0.6))),
                    ),
                  ))
        ])
      ]),
      Flexible(
          child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(
            begin: 0.0,
            end: _getRelativePosition(_getFieldValue(forecast, field),
                minHourlyValue, maxHourlyValue)),
        builder: (_, double leftRelativePos, __) {
          return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: leftRelativePos,
              child: Container(
                color: Color.fromARGB(255, 150, 150, 150),
                height: 1,
              ));
        },
      )),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: _getValueWidget())))
    ]);
  }

  Widget _getValueWidget() {
    if (field == "windSpeed") {
      return ValueWidgets.wind(
          _getFieldTextValue(forecast, field), forecast.windSpeed);
    } else {
      return ValueWidgets.simple(_getFieldTextValue(forecast, field));
    }
  }

  _getRelativePosition(val, minVal, maxVal) {
    if ((maxVal - minVal) == 0) {
      return 1.0;
    }

    return ((val - minVal) / (maxVal - minVal));
  }

  num _getFieldValue(Hourly forecast, String field) {
    if (field == "temp") {
      return forecast.temp;
    } else if (field == "feelsLike") {
      return forecast.feelsLike;
    } else if (field == "pressure") {
      return forecast.pressure;
    } else if (field == "humidity") {
      return forecast.humidity;
    } else if (field == "clouds") {
      return forecast.clouds;
    } else if (field == "rain") {
      return forecast.rain;
    } else if (field == "dewPoint") {
      return forecast.dewPoint;
    } else if (field == "windSpeed") {
      return forecast.windSpeed;
    } else if (field == "windDir") {
      return forecast.windDeg.toDouble();
    } else {
      return forecast.temp;
    }
  }

  String _getFieldTextValue(Hourly forecast, String field) {
    num value = _getFieldValue(forecast, field);

    if (field == "temp" || field == "feelsLike" || field == "dewPoint") {
      return '${value.toStringAsFixed(0)}°';
    } else if (field == "rain") {
      return '${value.toStringAsFixed(2)}"';
    } else if (field == "humidity" || field == "clouds") {
      return '${value.toStringAsFixed(0)}%';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}

import 'package:OpenSky/FieldSelectWidget.dart';
import 'package:OpenSky/HourlyWidget.dart';
import 'package:OpenSky/model/Hourly.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:core';

class HourlyForecastWidget extends StatefulWidget {
  final List<Hourly> forecast;

  const HourlyForecastWidget({Key key, this.forecast}) : super(key: key);

  @override
  _HourlyForecastWidgetState createState() => _HourlyForecastWidgetState();
}

class _HourlyForecastWidgetState extends State<HourlyForecastWidget>
    with SingleTickerProviderStateMixin {
  int numHoursToDisplay = 12;
  String selectedField = "temp";

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 1200),
        curve: Curves.easeOut,
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getNumHoursButton(12),
                  _getNumHoursButton(24),
                  _getNumHoursButton(48),
                ],
              )),
          numHoursToDisplay == 0
              ? Container()
              : Column(children: <Widget>[
                  ..._getHourlyList(
                      widget.forecast.take(numHoursToDisplay).toList(),
                      selectedField),
                  FieldSelectWidget(
                      field: selectedField,
                      fieldChanged: (f) {
                        setState(() {
                          selectedField = f;
                        });
                      },
                      showUvi: false),
                ]),
        ]));
  }

  Widget _getNumHoursButton(int numHours) {
    return _getSelectionButton(
        isSelected: numHoursToDisplay == numHours,
        message: '$numHours HOURS',
        onClicked: () {
          setState(() {
            if (numHoursToDisplay == numHours) {
              numHoursToDisplay = 0;
            } else {
              numHoursToDisplay = numHours;
            }
          });
        },
        padding: EdgeInsets.symmetric(horizontal: 8));
  }

  Widget _getSelectionButton(
      {bool isSelected,
      String message,
      Function onClicked,
      EdgeInsets padding}) {
    return Padding(
        padding: padding,
        child: new GestureDetector(
            onTap: () {
              onClicked();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 6, 10, 7),
              decoration: BoxDecoration(
                  color:
                      isSelected ? Theme.of(context).accentColor : Colors.white,
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).accentColor),
              ),
            )));
  }

  List<Widget> _getHourlyList(List<Hourly> data, String field) {
    var minHourly = _getHourlyVals(data, field).reduce(min);
    var maxHourly = _getHourlyVals(data, field).reduce(max);

    var items = new List<Widget>();
    for (int i = 0; i < data.length; i++) {
      if (data[i].dt.hour == 0) {
        items.add(Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                    new DateFormat('EEEE').format(data[i].dt).toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.start))));
      }

      items.add(HourlyWidget(
          forecast: data[i],
          field: field,
          minHourlyValue: minHourly,
          maxHourlyValue: maxHourly,
          hideDescription: i > 0 &&
              data[i - 1].weather[0].description ==
                  data[i].weather[0].description));
    }

    return items;
  }

  Iterable<num> _getHourlyVals(List<Hourly> data, String field) {
    if (field == "temp") {
      return data.map((h) => h.temp);
    } else if (field == "feelsLike") {
      return data.map((h) => h.feelsLike);
    } else if (field == "pressure") {
      return data.map((h) => h.pressure);
    } else if (field == "humidity") {
      return data.map((h) => h.humidity);
    } else if (field == "dewPoint") {
      return data.map((h) => h.dewPoint);
    } else if (field == "windSpeed") {
      return data.map((h) => h.windSpeed);
    } else if (field == "clouds") {
      return data.map((h) => h.clouds);
    } else if (field == "rain") {
      return data.map((h) => h.rain);
    } else {
      return data.map((h) => h.temp);
    }
  }
}

import 'package:OpenSky/DailyWidgetSimple.dart';
import 'package:OpenSky/DailyWidgetTemp.dart';
import 'package:OpenSky/FieldSelectWidget.dart';
import 'package:OpenSky/model/Daily.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DailyForecastWidget extends StatefulWidget {
  final List<Daily> forecast;
  DailyForecastWidget({Key key, this.forecast}) : super(key: key);

  @override
  _DailyForecastWidgetState createState() => _DailyForecastWidgetState();
}

class _DailyForecastWidgetState extends State<DailyForecastWidget> {
  String selectedField = "temp";

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ..._getDailyWidgets(widget.forecast),
      FieldSelectWidget(
        field: selectedField,
        fieldChanged: (f) {
          setState(() {
            selectedField = f;
          });
        },
        showUvi: true,
      )
    ]);
  }

  List<Widget> _getDailyWidgets(List<Daily> data) {
    if (selectedField == "temp" || selectedField == "feelsLike") {
      return _getDailyTempWidgets(data);
    } else {
      return _getDailySimpleWidgets(data);
    }
  }

  List<Widget> _getDailyTempWidgets(List<Daily> data) {
    var minDaily = _getDailyMinVals(data, selectedField).reduce(min);
    var maxDaily = _getDailyMaxVals(data, selectedField).reduce(max);

    var items = new List<Widget>();
    for (int i = 0; i < data.length; i++) {
      items.add(DailyWidgetTemp(
          forecast: data[i],
          field: selectedField,
          minDailyTemp: minDaily,
          maxDailyTemp: maxDaily));
    }
    return items;
  }

  List<Widget> _getDailySimpleWidgets(List<Daily> data) {
    var minDaily = _getDailySimpleVals(data, selectedField).reduce(min);
    var maxDaily = _getDailySimpleVals(data, selectedField).reduce(max);

    var items = new List<Widget>();
    for (int i = 0; i < data.length; i++) {
      items.add(DailyWidgetSimple(
          forecast: data[i],
          field: selectedField,
          minDailyValue: minDaily,
          maxDailyValue: maxDaily));
    }
    return items;
  }

  Iterable<num> _getDailyMinVals(List<Daily> data, String field) {
    if (field == "temp") {
      return data.map((h) => h.temp.min);
    } else {
      // (field == "feelsLike") {
      return data.map((h) => h.feelsLike.getMin());
    }
  }

  Iterable<num> _getDailyMaxVals(List<Daily> data, String field) {
    if (field == "temp") {
      return data.map((h) => h.temp.max);
    } else {
      // (field == "feelsLike") {
      return data.map((h) => h.feelsLike.getMax());
    }
  }

  Iterable<num> _getDailySimpleVals(List<Daily> data, String field) {
    if (field == "pressure") {
      return data.map((h) => h.pressure.toDouble());
    } else if (field == "humidity") {
      return data.map((h) => h.humidity.toDouble());
    } else if (field == "clouds") {
      return data.map((h) => h.clouds.toDouble());
    } else if (field == "dewPoint") {
      return data.map((h) => h.dewPoint);
    } else if (field == "windSpeed") {
      return data.map((h) => h.windSpeed);
    } else if (field == "uvi") {
      return data.map((h) => h.uvi.roundToDouble());
    } else {
      // (field == "rain") {
      return data.map((h) => h.rain);
    }
  }
}

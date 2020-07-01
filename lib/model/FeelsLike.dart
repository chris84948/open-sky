import 'dart:math';
import 'package:OpenSky/Ext.dart';

class FeelsLike {
  double day;
  double night;
  double eve;
  double morn;

  FeelsLike({this.day, this.night, this.eve, this.morn});

  FeelsLike.fromJson(Map<String, dynamic> json) {
    day = json.getDoubleSafe('day');
    night = json.getDoubleSafe('night');
    eve = json.getDoubleSafe('eve');
    morn = json.getDoubleSafe('morn');
  }

  double getMin() {
    return [day, night, eve, morn].reduce(min).toDouble();
  }

  double getMax() {
    return [day, night, eve, morn].reduce(max).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['night'] = this.night;
    data['eve'] = this.eve;
    data['morn'] = this.morn;
    return data;
  }
}

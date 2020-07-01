import 'package:OpenSky/Ext.dart';

class Temp {
  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

  Temp.fromJson(Map<String, dynamic> json) {
    day = json.getDoubleSafe('day');
    min = json.getDoubleSafe('min');
    max = json.getDoubleSafe('max');
    night = json.getDoubleSafe('night');
    eve = json.getDoubleSafe('eve');
    morn = json.getDoubleSafe('morn');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['min'] = this.min;
    data['max'] = this.max;
    data['night'] = this.night;
    data['eve'] = this.eve;
    data['morn'] = this.morn;
    return data;
  }
}

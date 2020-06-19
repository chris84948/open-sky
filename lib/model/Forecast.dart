import 'package:OpenSky/model/Current.dart';
import 'package:OpenSky/model/Daily.dart';
import 'package:OpenSky/model/Hourly.dart';
import 'package:OpenSky/model/Minutely.dart';

class Forecast {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  Current current;
  List<Minutely> minutely;
  List<Hourly> hourly;
  List<Daily> daily;

  Forecast(
      {this.lat,
      this.lon,
      this.timezone,
      this.timezoneOffset,
      this.current,
      this.minutely,
      this.hourly,
      this.daily});

  Forecast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toDouble();
    lon = json['lon'].toDouble();
    timezone = json['timezone'];
    timezoneOffset = json['timezone_offset'];
    current =
        json['current'] != null ? new Current.fromJson(json['current']) : null;
    if (json['minutely'] != null) {
      minutely = new List<Minutely>();
      json['minutely'].forEach((v) {
        minutely.add(new Minutely.fromJson(v));
      });
    }
    if (json['hourly'] != null) {
      hourly = new List<Hourly>();
      json['hourly'].forEach((v) {
        hourly.add(new Hourly.fromJson(v));
      });
    }
    if (json['daily'] != null) {
      daily = new List<Daily>();
      json['daily'].forEach((v) {
        daily.add(new Daily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['timezone'] = this.timezone;
    data['timezone_offset'] = this.timezoneOffset;
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.minutely != null) {
      data['minutely'] = this.minutely.map((v) => v.toJson()).toList();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly.map((v) => v.toJson()).toList();
    }
    if (this.daily != null) {
      data['daily'] = this.daily.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

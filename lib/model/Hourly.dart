import 'package:OpenSky/model/Weather.dart';
import 'package:OpenSky/Ext.dart';

class Hourly {
  DateTime dt;
  double temp;
  double feelsLike;
  double pressure;
  double humidity;
  double dewPoint;
  double clouds;
  double windSpeed;
  double windDeg;
  List<Weather> weather;
  double rain;

  Hourly(
      {this.dt,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.clouds,
      this.windSpeed,
      this.windDeg,
      this.weather,
      this.rain});

  Hourly.fromJson(Map<String, dynamic> json) {
    dt = new DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
    temp = json.getDoubleSafe('temp');
    feelsLike = json.getDoubleSafe('feels_like');
    pressure = json.getDoubleSafe('pressure');
    humidity = json.getDoubleSafe('humidity');
    dewPoint = json.getDoubleSafe('dew_point');
    clouds = json.getDoubleSafe('clouds');
    windSpeed = json.getDoubleSafe('wind_speed');
    windDeg = json.getDoubleSafe('wind_deg');
    if (json['weather'] != null) {
      weather = new List<Weather>();
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
    rain = json['rain'] != null ? json['rain']['1h'].toDouble() / 25.4 : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt.millisecondsSinceEpoch ~/ 1000;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['clouds'] = this.clouds;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    if (this.rain != null) {
      data['rain'] = <String, dynamic>{'1h': this.rain};
    }
    return data;
  }
}

import 'package:OpenSky/model/Weather.dart';
import 'package:OpenSky/Ext.dart';

class Current {
  DateTime dt;
  DateTime sunrise;
  DateTime sunset;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  List<Weather> weather;
  double rain;

  Current(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.weather,
      this.rain});

  Current.fromJson(Map<String, dynamic> json) {
    dt = new DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
    sunrise = new DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise'] as int) * 1000);
    sunset =
        new DateTime.fromMillisecondsSinceEpoch((json['sunset'] as int) * 1000);
    temp = json.getDoubleSafe('temp');
    feelsLike = json.getDoubleSafe('feels_like');
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json.getDoubleSafe('dew_point');
    uvi = json.getDoubleSafe('uvi');
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json.getDoubleSafe('wind_speed');
    windDeg = json['wind_deg'];
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
    data['sunrise'] = this.sunrise.millisecondsSinceEpoch ~/ 1000;
    data['sunset'] = this.sunset.millisecondsSinceEpoch ~/ 1000;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['uvi'] = this.uvi;
    data['clouds'] = this.clouds;
    data['visibility'] = this.visibility;
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

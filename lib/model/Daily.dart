import 'package:OpenSky/model/FeelsLike.dart';
import 'package:OpenSky/model/Temp.dart';
import 'package:OpenSky/model/Weather.dart';
import 'package:OpenSky/Ext.dart';

class Daily {
  DateTime dt;
  DateTime sunrise;
  DateTime sunset;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  List<Weather> weather;
  int clouds;
  double rain;
  double uvi;

  Daily(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.windSpeed,
      this.windDeg,
      this.weather,
      this.clouds,
      this.rain,
      this.uvi});

  Daily.fromJson(Map<String, dynamic> json) {
    dt = new DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
    sunrise = new DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise'] as int) * 1000);
    sunset =
        new DateTime.fromMillisecondsSinceEpoch((json['sunset'] as int) * 1000);
    temp = json['temp'] != null ? new Temp.fromJson(json['temp']) : null;
    feelsLike = json['feels_like'] != null
        ? new FeelsLike.fromJson(json['feels_like'])
        : null;
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json.getDoubleSafe('dew_point');
    windSpeed = json.getDoubleSafe('wind_speed');
    windDeg = json['wind_deg'];
    if (json['weather'] != null) {
      weather = new List<Weather>();
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
    clouds = json['clouds'];
    rain = json.getDoubleSafe('rain') / 25.4;
    uvi = json.getDoubleSafe('uvi');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt.millisecondsSinceEpoch ~/ 1000;
    data['sunrise'] = this.sunrise.millisecondsSinceEpoch ~/ 1000;
    data['sunset'] = this.sunset.millisecondsSinceEpoch ~/ 1000;
    if (this.temp != null) {
      data['temp'] = this.temp.toJson();
    }
    if (this.feelsLike != null) {
      data['feels_like'] = this.feelsLike.toJson();
    }
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    data['clouds'] = this.clouds;
    data['rain'] = this.rain;
    data['uvi'] = this.uvi;
    return data;
  }
}

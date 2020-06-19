class Minutely {
  DateTime dt;
  double precipitation;
  int intensity;

  Minutely({this.dt, this.precipitation});

  Minutely.fromJson(Map<String, dynamic> json) {
    dt = new DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
    precipitation = json['precipitation'].toDouble() / 25.4;
    intensity = _calculateIntensity(json['precipitation'].toDouble());
  }

  int _calculateIntensity(double precipMM) {
    if (precipMM == 0.0) {
      return 0;
    } else if (precipMM <= 1.0) {
      return 1;
    } else if (precipMM <= 2.5) {
      return 2;
    } else if (precipMM <= 4.5) {
      return 3;
    } else if (precipMM <= 7) {
      return 4;
    } else if (precipMM <= 10) {
      return 5;
    } else if (precipMM <= 13) {
      return 6;
    } else if (precipMM <= 16) {
      return 7;
    } else if (precipMM <= 20) {
      return 8;
    } else if (precipMM <= 25) {
      return 9;
    } else {
      return 10;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt.millisecondsSinceEpoch ~/ 1000;
    data['precipitation'] = this.precipitation;
    return data;
  }
}

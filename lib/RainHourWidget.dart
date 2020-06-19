import 'package:OpenSky/model/Minutely.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class RainHourWidget extends StatelessWidget {
  final List<Minutely> forecast;
  RainHourWidget({Key key, this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return forecast.any((element) => element.precipitation > 0)
        ? Column(children: <Widget>[
            Text('Upcoming Rain (intensity)'),
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: charts.TimeSeriesChart(
                    [
                      new charts.Series<Minutely, DateTime>(
                          id: 'Upcoming Rain',
                          displayName: 'Upcoming Rain',
                          measureLowerBoundFn: (_, __) => 0.0,
                          measureUpperBoundFn: (_, __) => 10.0,
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (Minutely minute, _) => minute.dt,
                          measureFn: (Minutely minute, _) => minute.intensity,
                          data: forecast)
                    ],
                    defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                    defaultInteractions: false,
                    animate: true,
                    animationDuration: Duration(milliseconds: 500),
                  )),
            )
          ])
        : Center(child: Text('No rain for the next hour'));
  }
}

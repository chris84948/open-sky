import 'package:OpenSky/model/Forecast.dart';
import 'package:OpenSky/Ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class OverviewWidget extends StatelessWidget {
  final Forecast forecast;
  OverviewWidget({Key key, this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: FractionallySizedBox(
                            widthFactor: 0.28,
                            alignment: Alignment.center,
                            child: Image(
                                image: AssetImage(
                                    'assets/${forecast.current.weather[0].icon}.png')))),
                    Padding(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                child: Text(
                                  '${forecast.current.temp.toStringAsFixed(0)}°',
                                  style: TextStyle(fontSize: 46),
                                ),
                                padding: EdgeInsets.fromLTRB(3, 0, 0, 0)),
                            Text(
                              'Feels ${forecast.current.feelsLike.toStringAsFixed(0)}°',
                              style: TextStyle(
                                  height: 0.8,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 5)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                child: Text(
                                  new DateFormat.jm()
                                      .format(forecast.current.sunrise),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 0)),
                            Padding(
                                padding: EdgeInsets.fromLTRB(8, 3, 0, 3),
                                child: Image(
                                  image: AssetImage('assets/sunrise.png'),
                                  width: 30,
                                )),
                            Padding(
                                child: Text(
                                  new DateFormat.jm()
                                      .format(forecast.current.sunset),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 0))
                          ],
                        ))
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      forecast.current.weather[0].description.capitalize(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ],
            ))
      ],
    );
  }
}

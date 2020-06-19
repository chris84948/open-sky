import 'package:flutter/material.dart';

class FieldSelectWidget extends StatelessWidget {
  final String field;
  final Function(String) fieldChanged;
  final bool showUvi;
  FieldSelectWidget({Key key, this.field, this.fieldChanged, this.showUvi});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 5),
        scrollDirection: Axis.horizontal,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: <Widget>[
                Container(width: 5),
                _getFieldButton('temp', context),
                _getFieldButton('feelsLike', context),
                _getFieldButton('rain', context),
                _getFieldButton("windSpeed", context),
                _getFieldButton('humidity', context),
                _getFieldButton('dewPoint', context),
                showUvi
                    ? _getFieldButton('uvi', context)
                    : Container(width: 0, height: 0),
                _getFieldButton('clouds', context),
                _getFieldButton('pressure', context),
                Container(width: 5)
              ],
            )));
  }

  Widget _getFieldButton(String field, BuildContext context) {
    return _getSelectionButton(
        isSelected: this.field == field,
        message: _getFieldReadable(field),
        onClicked: () {
          this.fieldChanged(field);
        },
        padding: EdgeInsets.symmetric(horizontal: 2.5),
        context: context);
  }

  Widget _getSelectionButton(
      {bool isSelected,
      String message,
      Function onClicked,
      EdgeInsets padding,
      BuildContext context}) {
    return Padding(
        padding: padding,
        child: new GestureDetector(
            onTap: () {
              onClicked();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 6, 10, 7),
              decoration: BoxDecoration(
                  color:
                      isSelected ? Theme.of(context).accentColor : Colors.white,
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).accentColor),
              ),
            )));
  }

  String _getFieldReadable(String field) {
    if (field == "temp") {
      return 'TEMP (°F)';
    } else if (field == "feelsLike") {
      return 'FEELS-LIKE (°F)';
    } else if (field == "pressure") {
      return 'PRESSURE (MB)';
    } else if (field == "dewPoint") {
      return 'DEW POINT (°F)';
    } else if (field == "humidity") {
      return 'HUMIDITY (%)';
    } else if (field == "clouds") {
      return 'CLOUD COVER (%)';
    } else if (field == "windSpeed") {
      return 'WIND (MPH)';
    } else if (field == "uvi") {
      return 'UV INDEX';
    } else if (field == "rain") {
      return 'RAIN (IN)';
    } else {
      return 'TEMP (°F)';
    }
  }
}

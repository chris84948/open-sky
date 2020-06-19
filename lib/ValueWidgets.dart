import 'package:flutter/material.dart';
import 'dart:math' as math;

class ValueWidgets {
  static Widget simple(String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 3, 7, 3.5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 70, 70, 70),
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        value,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  static Widget uvIndex(String value) {
    int uvIndex = int.tryParse(value);

    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3.5),
      decoration: BoxDecoration(
          color: _getUVColor(uvIndex), borderRadius: BorderRadius.circular(12)),
      child: Text(
        value,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  static Color _getUVColor(int num) {
    if (num <= 2) {
      return new Color(0xff589A5D);
    } else if (num <= 5) {
      return new Color(0xffB3AF38);
    } else if (num <= 7) {
      return new Color(0xffB27D58);
    } else if (num <= 10) {
      return new Color(0xffA75051);
    } else {
      return new Color(0xff746198);
    }
  }

  static Widget wind(String value, double windDir) {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 5, 3.5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 70, 70, 70),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: <Widget>[
        Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Transform.rotate(
            child: Icon(Icons.arrow_upward, color: Colors.white, size: 15),
            angle: windDir)
      ]),
    );
  }
}

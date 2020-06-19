import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'OpenSky.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(OpenSky());
}

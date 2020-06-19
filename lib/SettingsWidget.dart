import 'dart:convert';
import 'package:OpenSky/model/Settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SettingsWidget extends StatefulWidget {
  final Settings settings;
  final Function(Settings) settingsChanged;
  SettingsWidget({Key key, this.settings, this.settingsChanged})
      : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  Settings settings;
  @override
  void initState() {
    settings = widget.settings ?? Settings.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Open Sky Setup"),
          actions: <Widget>[
            new FlatButton(
                child: new Text('SAVE',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  _saveSettings();
                })
          ],
        ),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                    TextSpan(
                        text:
                            'This app doesn\'t pay for API access, so you\'ll have to sign up for your own API key to use it.\n\nGo to '),
                    TextSpan(
                        text: 'https://home.openweathermap.org/users/sign_up',
                        style: new TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => launch(
                              'https://home.openweathermap.org/users/sign_up')),
                    TextSpan(
                        text:
                            ' to get a free key (60 calls/min) to work the app.'),
                  ]))),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextFormField(
                initialValue: settings.apiKey,
                textCapitalization: TextCapitalization.words,
                // cursorColor: cursorColor,
                decoration: InputDecoration(
                    filled: true,
                    hintText: 'Enter API key here',
                    labelText: 'Open Weather Maps API Key'),
                onChanged: (text) async {
                  settings.apiKey = text;
                },
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('Use GPS Location Services')),
                  Switch(
                      value: settings.useLocation,
                      onChanged: (val) async {
                        bool locationAvailable =
                            await _checkLocationServicesAreAvailable(context);

                        // If it's not available, this checkbox will be set to false again
                        setState(() {
                          settings.useLocation = val && locationAvailable;
                        });
                      })
                ],
              )),
          settings.useLocation
              ? new Container()
              : Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    initialValue: settings.zipCode,
                    // cursorColor: cursorColor,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter 5-digit zipcode',
                        labelText: 'US Zip Code'),
                    onChanged: (text) {
                      if (text.length == 5 && int.tryParse(text) != null) {
                        settings.zipCode = text;
                      }
                    },
                  )),
        ]));
  }

  Future _saveSettings() async {
    settings.areValid = await _checkIfSettingsAreValid();

    if (settings.areValid) {
      if (widget.settingsChanged != null) {
        widget.settingsChanged(settings);
      } else {
        Navigator.of(context).pop(settings);
      }
    } else {
      _showErrorDialog(context, 'Settings Issue',
          'Settings are not valid. Check settings are configured correctly before trying again.');
    }
  }

  Future<bool> _checkIfSettingsAreValid() async {
    if (settings.apiKey == null || settings.apiKey == '') {
      return false;
    } else if (!settings.useLocation && settings.zipCode.length != 5) {
      return false;
    }

    // Finally, check the API key is valid
    return await _isApiKeyValid(context, settings.apiKey);
  }

  Future<bool> _checkLocationServicesAreAvailable(BuildContext context) async {
    if (!(await _isLocationServiceEnabled())) {
      _showErrorDialog(context, 'Location Services Error!',
          'Cannot use location services while they are not enabled.\n\nYou can still use this app by entering your zip code.');
      return false;
    }

    if (await _isLocationPermissionGranted() == PermissionStatus.denied) {
      _showErrorDialog(context, 'Location Services Error!',
          'Location permissions were denied.\n\nYou can still use this app by entering your zip code.');
      return false;
    }

    return true;
  }

  Future<bool> _isLocationServiceEnabled() async {
    Location location = new Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    return true;
  }

  Future<PermissionStatus> _isLocationPermissionGranted() async {
    Location location = new Location();

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    return permissionGranted;
  }

  Future<bool> _isApiKeyValid(BuildContext context, String apiKey) async {
    var response = await http.get(
        'https://api.openweathermap.org/data/2.5/onecall?lat=44.9527428&lon=-93.384132&units=imperial&appid=${apiKey}');

    if (response.statusCode >= 400) {
      _showErrorDialog(
          context, 'API Key Error!', jsonDecode(response.body)['message']);
      return false;
    } else {
      return true;
    }
  }

  void _showErrorDialog(BuildContext context, String title, String errorMsg) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(title),
              content: new Text(errorMsg),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}

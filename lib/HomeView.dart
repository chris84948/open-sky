import 'dart:convert';
import 'package:OpenSky/DailyForecastWidget.dart';
import 'package:OpenSky/HourlyForecastWidget.dart';
import 'package:OpenSky/MapFullScreenWidget.dart';
import 'package:OpenSky/MapSimpleWidget.dart';
import 'package:OpenSky/OverviewWidget.dart';
import 'package:OpenSky/RainHourWidget.dart';
import 'package:OpenSky/SettingsWidget.dart';
import 'package:OpenSky/model/Forecast.dart';
import 'package:OpenSky/model/Settings.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  static const int TAB_MAIN = 0, TAB_MAP = 1;
  static const int MIN_REFRESH_TIME = 5;
  int _selectedIndex;
  LatLng _latLongCoords;
  Forecast _forecast;
  Settings _settings;

  @override
  void initState() {
    _selectedIndex = TAB_MAIN;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _checkForDataRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _settings != null) {
      _checkForDataRefresh();
    }
  }

  Future _checkForDataRefresh() async {
    var data = await _grabForecastData();
    setState(() {
      _forecast = data;
    });

    // We should have some data already, so now just try and check for a newer version if we need it
    _refreshForecastData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Open Sky'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await _checkForDataRefresh();
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                if (_settings == null) {
                  _settings = await _loadSettingsFromJson();
                }
                await _showSettingsDialog(context);
                var data = await _queryForecastData();
                if (data != null) {
                  setState(() {
                    _forecast = data;
                  });
                }
              },
            ),
          ],
        ),
        body: _forecast == null
            ? Align(
                alignment: Alignment.center, child: CircularProgressIndicator())
            : _getTabViewWidgets(),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Color.fromARGB(255, 150, 150, 150),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('HOME'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('RADAR'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (i) async {
            setState(() {
              _selectedIndex = i;
            });
          },
        ));
  }

  Widget _getTabViewWidgets() {
    if (_selectedIndex == TAB_MAIN) {
      return RefreshIndicator(
          onRefresh: () async {
            await _checkForDataRefresh();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              OverviewWidget(forecast: _forecast),
              MapSimpleWidget(
                  lat: _forecast.lat,
                  long: _forecast.lon,
                  mapClicked: () {
                    setState(() {
                      _selectedIndex = TAB_MAP;
                    });
                  }),
              RainHourWidget(forecast: _forecast.minutely),
              HourlyForecastWidget(forecast: _forecast.hourly),
              DailyForecastWidget(forecast: _forecast.daily)
            ],
          ));
    } else {
      // TAB_MAP
      return MapFullScreenWidget(lat: _forecast.lat, long: _forecast.lon);
    }
  }

  Future<Settings> _showSettingsDialog(BuildContext context) async {
    var newSettings =
        await Navigator.of(context).push(new MaterialPageRoute<Settings>(
            builder: (BuildContext context) {
              return SettingsWidget(settings: _settings);
            },
            fullscreenDialog: true));

    if (newSettings == null) return null;
    await _saveSetting('settings', json.encode(newSettings));
    return newSettings;
  }

  Future<Forecast> _getJson(int num) async {
    var jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/data_sample$num.json");
    Map forecastMap = jsonDecode(jsonString);
    return Forecast.fromJson(forecastMap);
  }

  Future<Forecast> _grabForecastData() async {
    _forecast = await _grabForecastFromMemory();
    if (_forecast != null) {
      return _forecast;
    }

    // Grab the latest and store it
    _forecast = await _queryForecastData();
    return _forecast;
  }

  Future<Forecast> _grabForecastFromMemory() async {
    if (_forecast != null) {
      return _forecast;
    }

    String forecastJson = await _loadSetting('forecast');
    if (forecastJson != null) {
      _forecast = Forecast.fromJson(jsonDecode(forecastJson));
      return _forecast;
    }

    return null;
  }

  Future _loadSettingsIfNeeded() async {
    // finally, we've got no other choice, do a full call
    if (_settings != null) {
      return;
    }

    _settings = await _loadSettingsFromJson();
    if (_settings == null) {
      _settings = await _showSettingsDialog(context);
    }
  }

  Future<Settings> _loadSettingsFromJson() async {
    String settingsJson = await _loadSetting('settings');
    if (settingsJson != null) {
      return Settings.fromJson(jsonDecode(settingsJson));
    } else {
      return null;
    }
  }

  _refreshForecastData() async {
    if (new DateTime.now().difference(_forecast.current.dt).inMinutes <
        MIN_REFRESH_TIME) {
      return;
    }

    var data = await _queryForecastData();
    if (data != null) {
      setState(() {
        _forecast = data;
      });
    }
  }

  Future<Forecast> _queryForecastData() async {
    try {
      await _loadSettingsIfNeeded();
      _latLongCoords = await _getLatLongCoords(_settings.useLocation);

      var response = await http.get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=${_latLongCoords.latitude}&lon=${_latLongCoords.longitude}&units=imperial&appid=${_settings.apiKey}');

      if (response.statusCode >= 400) {
        _showErrorDialog(
            'API Key Error!', jsonDecode(response.body)['message']);
        return null;
      }

      // save forecast to local mem
      _saveSetting('forecast', response.body);
      Map forecastMap = jsonDecode(response.body);
      return Forecast.fromJson(forecastMap);
    } catch (ex) {
      _showErrorDialog('Query Forecast Error!', ex.toString());
    }

    return null;
  }

  Future<LatLng> _getLatLongCoords(bool _useLocationServices) async {
    if (_useLocationServices) {
      var locationData = await _getLocationData();
      return LatLng(locationData.latitude, locationData.longitude);
    } else {
      // Zip code
      var address =
          await Geocoder.local.findAddressesFromQuery(_settings.zipCode);
      if (address == null) return null;

      return LatLng(
          address[0].coordinates.latitude, address[0].coordinates.longitude);
    }
  }

  Future<LocationData> _getLocationData() async {
    return await new Location().getLocation();
  }

  void _showErrorDialog(String title, String errorMsg) {
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

  dynamic _loadSetting(String settingName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.get(settingName);
    } catch (e) {
      print(e);
      return null;
    }
  }

  _saveSetting(String settingName, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(settingName, value);
    } else if (value is double) {
      prefs.setDouble(settingName, value);
    } else if (value is String) {
      prefs.setString(settingName, value);
    } else if (value is bool) {
      prefs.setBool(settingName, value);
    } else {
      throw new UnimplementedError('This setting type cannot save - $value');
    }
  }
}

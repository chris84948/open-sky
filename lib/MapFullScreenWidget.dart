import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFullScreenWidget extends StatefulWidget {
  final double lat, long;
  final String apiKey;
  MapFullScreenWidget({Key key, this.lat, this.long, this.apiKey});

  @override
  State<MapFullScreenWidget> createState() => MapFullScreenWidgetState();
}

class MapFullScreenWidgetState extends State<MapFullScreenWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  bool _animating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(_animating ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _animating = !_animating;
                _mapController.setTileAnimation(_animating);

                if (_animating) {
                  _displaySnackbarMessage(context);
                }
              });
            }),
        body: Container(
          child: getMap(),
        ));
  }

  GoogleMap getMap() {
    return GoogleMap(
        mapType: MapType.terrain,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 6),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _controller.complete(controller);
        });
  }

  _displaySnackbarMessage(BuildContext context) {
    final snackBar = SnackBar(content: Text('Showing radar for last 2 hours!'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

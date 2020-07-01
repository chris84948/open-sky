import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSimpleWidget extends StatefulWidget {
  final double lat, long;
  final Function mapClicked;
  final String apiKey;
  final int mapRefresh;
  MapSimpleWidget(
      {Key key,
      this.lat,
      this.long,
      this.mapClicked,
      this.apiKey,
      this.mapRefresh});

  @override
  State<MapSimpleWidget> createState() => MapSimpleWidgetState();
}

class MapSimpleWidgetState extends State<MapSimpleWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    if (_mapController != null) {
      _mapController.refreshTiles();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      height: MediaQuery.of(context).size.height / 6,
      child: getMap(),
    );
  }

  GoogleMap getMap() {
    return GoogleMap(
      onTap: (latLong) {
        if (widget?.mapClicked != null) {
          widget.mapClicked();
        }
      },
      mapType: MapType.terrain,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition:
          CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 5),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _controller.complete(controller);
      },
    );
  }
}

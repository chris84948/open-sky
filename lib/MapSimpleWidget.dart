import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSimpleWidget extends StatelessWidget {
  final double lat, long;
  final Function mapClicked;
  final String apiKey;
  final Completer<GoogleMapController> _controller = Completer();
  MapSimpleWidget({Key key, this.lat, this.long, this.mapClicked, this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      height: MediaQuery.of(context).size.height / 6,
      child: getMap(),
    );
  }

  GoogleMap getMap() {
    return GoogleMap(
      onTap: (latLong) {
        if (mapClicked != null) {
          mapClicked();
        }
      },
      mapType: MapType.terrain,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 5),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}

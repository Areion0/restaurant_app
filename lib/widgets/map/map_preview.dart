import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPreview extends StatefulWidget {
  final LatLng initialLocation;
  final Function onMapCreated;
  const MapPreview({
    required this.initialLocation,
    required this.onMapCreated,
    super.key,
  });

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  late final CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();

    _initialPosition = CameraPosition(
      target: LatLng(widget.initialLocation.latitude + 0.000015, widget.initialLocation.longitude),
      zoom: 19,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: const EdgeInsets.all(240.0),
      initialCameraPosition: _initialPosition,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: false,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: false,
      style: """
            [
                {
                  "featureType": "poi",
                  "elementType": "all",
                  "stylers": [
                    {
                      "visibility": "off"
                    }
                  ]
                }
            ]
            """,
      zoomControlsEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId('initialLocation'),
          position: widget.initialLocation,
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        widget.onMapCreated();
        _controller.complete(controller);
      },
    );
  }
}

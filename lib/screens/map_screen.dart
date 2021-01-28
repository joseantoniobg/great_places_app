import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  LatLng pickedLocation;

  MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 37.5, longitude: -122.084),
      this.isSelecting = false}) {
    if (!isSelecting) {
      pickedLocation =
          LatLng(initialLocation.latitude, initialLocation.longitude);
    }
  }
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _selectLocation(LatLng position) {
    setState(() {
      widget.pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Selector'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                icon: Icon(Icons.check),
                onPressed: widget.pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(widget.pickedLocation);
                      }),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: widget.pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: widget.pickedLocation,
                ),
              },
      ),
    );
  }
}

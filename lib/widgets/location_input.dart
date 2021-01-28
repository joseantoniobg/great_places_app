import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool _isLoading = false;

  Future<void> _getCurrentUserLocation({double lat, double lng}) async {
    setState(() {
      _isLoading = true;
    });
    var locationData;
    if (lat == null) {
      locationData = await Location().getLocation();
      lat = locationData.latitude;
      lng = locationData.longitude;
    }

    final previewMapURL = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = previewMapURL;
      _isLoading = false;
    });
    widget.onSelectPlace(lat, lng);
  }

  Future<void> _getLocationFromMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _getCurrentUserLocation(
        lat: selectedLocation.latitude, lng: selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          width: double.infinity,
          child: _isLoading
              ? CircularProgressIndicator()
              : _previewImageUrl == null
                  ? Text(
                      'No location chosen!',
                      textAlign: TextAlign.center,
                    )
                  : Image.network(
                      _previewImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _isLoading ? null : _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getLocationFromMap,
            )
          ],
        )
      ],
    );
  }
}

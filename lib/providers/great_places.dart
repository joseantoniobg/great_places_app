import 'dart:io';

import 'package:flutter/foundation.dart';
import '../helpers/location_helper.dart';
import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    String address = await LocationHelper.getPlaceAddress(
      location.latitude,
      location.longitude,
    );
    final newPlace = new Place(
      id: DateTime.now().toString(),
      title: title,
      location: PlaceLocation(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address),
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getdata('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
            image: File(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }

  Place getPlace(String id) {
    return _items.firstWhere((place) => place.id == id);
  }
}

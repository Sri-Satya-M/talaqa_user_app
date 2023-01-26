import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repository/location_repo.dart';

class LocationBloc with ChangeNotifier {
  final _locationRepo = LocationRepo();

  Placemark? address;
  LatLng? currentPosition;

  Future autoComplete(String search) async {
    return await _locationRepo.autoComplete(search);
  }

  Future decodePlace(String placeId) async {
    return await _locationRepo.decodePlace(placeId);
  }

  void setAddress(Placemark? address) {
    this.address = address;
    notifyListeners();
  }
}

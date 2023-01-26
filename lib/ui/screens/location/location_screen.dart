import 'dart:async';

import 'package:alsan_app/bloc/location_bloc.dart';
import 'package:alsan_app/ui/screens/location/widgets/location_search_box.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../main/home/booking/widgets/add_location_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationScreen(),
      ),
    );
  }

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _controller = Completer();
  GoogleMapController? _mapController;

  Position? position;
  CameraPosition? cameraPosition;
  Placemark? address;
  LatLng? latLng;
  Marker? marker;

  @override
  void initState() {
    latLng = const LatLng(17.385044, 78.486671);
    marker = const Marker(
      markerId: MarkerId('1'),
      position: LatLng(17.385044, 78.486671),
      infoWindow: InfoWindow(title: 'Google Maps'),
    );
    cameraPosition = const CameraPosition(
      target: LatLng(17.385044, 78.486671),
      zoom: 14,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = Provider.of<LocationBloc>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
                initialCameraPosition: cameraPosition!,
                compassEnabled: true,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  _mapController = await _controller.future;
                },
                markers: Set<Marker>.of([marker!]),
                onTap: (latLng) async {
                  this.latLng = latLng;
                  await markMyLocation();
                }),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: SafeArea(
              child: LocationSearchBox(
                onTap: (LatLng? latLng) async {
                  this.latLng = latLng;
                  await markMyLocation();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickGpsLocation,
        child: const Icon(Icons.my_location, size: 25),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: ProgressButton(
            onPressed: () {
              locationBloc.setAddress(address);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AddLocationScreen(),
                ),
              );
            },
            child: const Text('Confirm Location'),
          ),
        ),
      ),
    );
  }

  updateCameraPosition() {
    cameraPosition = CameraPosition(
      target: latLng!,
      zoom: 20,
    );

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );
  }

  markMyLocation() async {
    marker = Marker(
      markerId: const MarkerId('1'),
      draggable: true,
      position: latLng!,
      infoWindow: const InfoWindow(title: 'Your Location'),
    );
    updateCameraPosition();
    var placeMarks = await placemarkFromCoordinates(
      latLng!.latitude,
      latLng!.longitude,
    );
    address = placeMarks.first;
    setState(() {});
  }

  pickGpsLocation() async {
    ProgressUtils.handleProgress(
      context,
      task: () async {
        var permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        }

        switch (permission) {
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
            return ErrorSnackBar.show(context, 'Location Permission Denied');
        }

        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latLng = LatLng(position!.latitude, position!.longitude);
        await markMyLocation();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  LatLng _userLocation = LatLng(0.0, 0.0); // Default location

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    liveLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool isEnabled = await Geolocator.openLocationSettings();
      if (!isEnabled) {
        return Future.error('Location Service Disabled');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission Denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission Denied Forever');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void liveLocation() {
    LocationSettings locationOptions = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Set the distance filter as needed
    );

    Geolocator.getPositionStream(locationSettings: locationOptions)
        .listen((position) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return GoogleMap(
    //   initialCameraPosition: CameraPosition(
    //     target: _userLocation,
    //     zoom: 12,
    //   ),
    //   markers: {
    //     Marker(
    //       markerId: const MarkerId('user_location'),
    //       position: _userLocation,
    //       infoWindow: const InfoWindow(title: 'Your Location'),
    //     ),
    //   },
    // );
  }
}

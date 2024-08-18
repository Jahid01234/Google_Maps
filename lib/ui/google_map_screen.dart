import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Location _locationController = Location();
  GoogleMapController? _mapController ;
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: const Text("Google Maps"),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: const CameraPosition(
            target: _pGooglePlex,
            zoom: 13
        ),
        markers: {
          Marker(
              markerId:  const MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: currentPosition!
          ),
          const Marker(
              markerId: MarkerId("SourceLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _pGooglePlex
          ),
          const Marker(
              markerId: MarkerId("DestinationLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _pApplePark
          ),
        },
        onMapCreated: (GoogleMapController controller){
          _mapController = controller;
        },
      ),
    );
  }

  // Update Location on map method
  Future<void> getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(currentPosition!);
      }
    });
  }
}




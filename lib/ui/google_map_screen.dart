import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_map_app/constant.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await initializeMap());
    // getLocationUpdate();
    // getPolylinePoints().then((coordinates) {
    //   if (coordinates.isNotEmpty) {
    //     generatePolyLineFromPoints(coordinates);
    //   }
    // });
  }

  Future<void> initializeMap() async{
    await getLocationUpdate();
    final coordinates = await getPolylinePoints();
    generatePolyLineFromPoints(coordinates);
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
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: currentPosition!,
          ),
          const Marker(
            markerId: MarkerId("SourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex,
          ),
          const Marker(
            markerId: MarkerId("DestinationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pApplePark,
          ),
        },
        onMapCreated: (GoogleMapController controller) =>
            _mapController.complete(controller),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  // Move the marker on the map
  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: position,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  // Update Location on map
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
          _cameraToPosition(currentPosition!);
        });
      }
    });
  }

  // Draw line between points on the map
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GoogleApiKey,
         request: PolylineRequest(
             origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
             destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
             mode: TravelMode.driving,
        ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  // Generate Line draw
  Future<void> generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("Poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.redAccent,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}


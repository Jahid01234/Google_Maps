// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:google_map_app/constant.dart';
//
// class GoogleMapScreen extends StatefulWidget {
//   const GoogleMapScreen({super.key});
//
//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }
//
// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   final Location _locationController = Location();
//   final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>() ;
//   static const LatLng _sourceLocation = LatLng(23.36947922415758, 90.07162872701883);
//   static const LatLng _destinationLocation = LatLng(23.365022609228223, 90.08435647934675);
//   LatLng? currentPosition;
//   Map<PolylineId, Polyline> _polyLines = {};
//
//   @override
//   void initState()  {
//      super.initState();
//     // WidgetsBinding.instance
//     //     .addPostFrameCallback((_) async => await initializeMap());
//     getLocationUpdate().then(
//         (_)=> {
//           getPolylinePoints().then((coordinates)=>{
//             print(coordinates),
//             generatePolyLineFromPoints(coordinates),
//            },
//           ),
//         },
//     );
//
//   }
//
//   // Future<void> initializeMap() async {
//   //   await getLocationUpdate();
//   //   final coordinates = await getPolylinePoints();
//   //   generatePolyLineFromPoints(coordinates);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue,
//         foregroundColor: Colors.white,
//         title: const Text("Real-Time Location Tracker"),
//         centerTitle: true,
//       ),
//       body: currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: const CameraPosition(
//                 target: _sourceLocation,
//                 zoom: 13,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("currentLocation"),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueRose,
//                   ),
//                   position: currentPosition!,
//                   infoWindow: InfoWindow(
//                       title: "My Current Location",
//                       snippet: "${currentPosition!.latitude}, ${currentPosition!.longitude}",
//                       onTap: () {
//                         print("${currentPosition!.latitude}, ${currentPosition!.longitude}",);
//                       },
//                   ),
//                 ),
//                 const Marker(
//                   markerId: MarkerId("SourceLocation"),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _sourceLocation,
//                   infoWindow: InfoWindow(
//                     title: "Source Location",
//                   ),
//                 ),
//                 const Marker(
//                   markerId: MarkerId("DestinationLocation"),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _destinationLocation,
//                   infoWindow: InfoWindow(
//                     title: "Destination Location",
//                   ),
//                 ),
//               },
//               onMapCreated: (GoogleMapController controller) {
//                  _mapController.complete(controller);
//                 // getPolylinePoints();
//                  },
//               polylines: Set<Polyline>.of(_polyLines.values),
//               onTap: (LatLng latLng) {
//                 print(latLng);
//               },
//               zoomControlsEnabled: true,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//     );
//   }
//
//   // Move the marker on the map
//   Future<void> _cameraToPosition(LatLng position) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: position,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }
//
//   // Update Location on map
//   Future<void> getLocationUpdate() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await _locationController.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _locationController.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     permissionGranted = await _locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           currentPosition =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(currentPosition!);
//         });
//       }
//     });
//   }
//
//
//   // Draw line between points on the map
//   Future<List<LatLng>> getPolylinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: GoogleApiKey,
//       request: PolylineRequest(
//         origin: PointLatLng(_sourceLocation.latitude, _sourceLocation.longitude),
//         destination: PointLatLng(_destinationLocation.latitude, _destinationLocation.longitude),
//         mode: TravelMode.driving,
//       ),
//     );
//     if (result.points.isNotEmpty) {
//        result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         //generatePolyLineFromPoints(polylineCoordinates);
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polylineCoordinates;
//   }
//
//
//   // Generate Line draw
//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates)  {
//     PolylineId id = const PolylineId("Poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       points: polylineCoordinates,
//       color: Colors.lightBlue,
//       width: 4,
//     );
//     setState(() {
//       _polyLines[id] = polyline;
//     });
//   }
//



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
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>() ;
  static const LatLng _sourceLocation = LatLng(23.36947922415758, 90.07162872701883);
  static const LatLng _destinationLocation = LatLng(23.365022609228223, 90.08435647934675);
  final Map<PolylineId, Polyline> _polyLines = {};
  LatLng? currentPosition;

  @override
  void initState()  {
    super.initState();
    getLocationUpdate().then(
          (_)=> {
        getPolylinePoints().then((coordinates)=>{
          generatePolyLineFromPoints(coordinates),
        },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: const Text("Real-Time Location Tracker"),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: _sourceLocation,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
            position: currentPosition!,
            infoWindow: InfoWindow(
              title: "My Current Location",
              snippet: "${currentPosition!.latitude}, ${currentPosition!.longitude}",
              onTap: () {
                print("${currentPosition!.latitude}, ${currentPosition!.longitude}");
              },
            ),
          ),
          const Marker(
            markerId: MarkerId("SourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _sourceLocation,
            infoWindow: InfoWindow(
              title: "Source Location",
            ),
          ),
          const Marker(
            markerId: MarkerId("DestinationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _destinationLocation,
            infoWindow: InfoWindow(
              title: "Destination Location",
            ),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        polylines: Set<Polyline>.of(_polyLines.values),
        onTap: (LatLng latLng) {
          print(latLng);
        },
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  // Move the marker on the map
  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: position,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
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
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(currentPosition!);
          _updatePolyline();
        });
      }
    });
  }

  // Get polyline between currentPosition and destination
  void _updatePolyline() async {
    if (currentPosition != null) {
      final coordinates = await getPolylinePoints();
      generatePolyLineFromPoints(coordinates);
    }
  }

  // Draw line between points on the map
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    if (currentPosition == null) return polylineCoordinates;

    PolylinePoints polylinePoints = PolylinePoints();

    // Source to Current Location
    PolylineResult resultSourceToCurrent = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GoogleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_sourceLocation.latitude, _sourceLocation.longitude),
        destination: PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (resultSourceToCurrent.points.isNotEmpty) {
      resultSourceToCurrent.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Current Location to Destination
    PolylineResult resultCurrentToDestination = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GoogleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        destination: PointLatLng(_destinationLocation.latitude, _destinationLocation.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (resultCurrentToDestination.points.isNotEmpty) {
      resultCurrentToDestination.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    return polylineCoordinates;
  }

  // Generate Line draw
  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates)  {
    PolylineId id = const PolylineId("Poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.lightBlue,
      width: 4,
    );
    setState(() {
      _polyLines[id] = polyline;
    });
  }
}




// Import necessary libraries
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location;
import 'package:location/location.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  Marker? origin;
  Marker? destination;
  final LatLng _initPos = const LatLng(6.6622667, -1.54756467);

  final Completer<GoogleMapController> _mapcontroller =
      Completer<GoogleMapController>();
  LatLng? _userPos;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Set<Polyline> _polylines = {};
  String? _userPhoto;
  MapType _currentMapType = MapType.normal; // Selected map type

  @override
  void initState() {
    super.initState();
    getPositionUpdate();
    getUserPhoto();
  }

  Future<void> getUserPhoto() async {
    try {
      final String uid = _auth.currentUser!.uid;
      final Reference userPhotoRef =
          _storage.ref().child('users/$uid/profile_pic.jpg');
      final String downloadURL = await userPhotoRef.getDownloadURL();
      setState(() {
        _userPhoto = downloadURL;
      });
    } catch (error) {
      print('Error fetching user photo: $error');
    }
  }

  void _addMarker(LatLng pos) {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          position: pos,
        );
        destination = null;
        _polylines.clear();
      });
    } else {
      setState(() {
        destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          position: pos,
        );
        if (origin != null) {
          //
        }
      });
    }
  }

  Future<void> updateCameraPo(LatLng position) async {
    final GoogleMapController controller = await _mapcontroller.future;
    await controller.moveCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> getPositionUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.Location().serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await location.Location().requestService();
    } else {
      return;
    }
    permissionGranted = await location.Location().hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.Location().requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.Location()
        .onLocationChanged
        .listen((location.LocationData currentLoc) {
      if (currentLoc.latitude != null && currentLoc.longitude != null) {
        setState(() {
          _userPos = LatLng(currentLoc.latitude!, currentLoc.longitude!);
          updateCameraPo(_userPos!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Current Loaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              List<geocoding.Location> locations =
                  await geocoding.locationFromAddress(
                      _searchController.text); // Using the prefix
              if (locations.isNotEmpty) {
                LatLng searchLocation =
                    LatLng(locations[0].latitude, locations[0].longitude);
                setState(() {
                  _searchController.text = '';
                  origin = null;
                  destination = Marker(
                    markerId: const MarkerId('destination'),
                    infoWindow: const InfoWindow(title: 'User'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                    position: searchLocation,
                  );
                });
              }
            },
          ),
          _buildMapTypeDropdownButton(), // Add the dropdown button
        ],
      ),
      body: Stack(
        children: [
          _userPos == null
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : GoogleMap(
                  mapType: _currentMapType, // Set the map type
                  mapToolbarEnabled: true,
                  compassEnabled: true,
                  indoorViewEnabled: true,
                  myLocationEnabled: true,
                  buildingsEnabled: true,
                  onLongPress: _addMarker,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) =>
                      _mapcontroller.complete(controller),
                  initialCameraPosition:
                      CameraPosition(target: _initPos, zoom: 12),
                  markers: {
                    if (origin != null) origin!,
                    if (destination != null) destination!,
                    Marker(
                      markerId: const MarkerId('userPo'),
                      icon: _userPhoto != null
                          ? BitmapDescriptor.fromBytes(
                              Uint8List.fromList(_userPhoto!.codeUnits))
                          : BitmapDescriptor.defaultMarker,
                      position: _userPos!,
                    ),
                  },
                  polylines: _polylines,
                ),
          Positioned(
            bottom: 15.0,
            left: 70.0,
            right: 100,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              height: 40,
              width: MediaQuery.of(context).size.width - 20,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for places...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTypeDropdownButton() {
    return DropdownButton<MapType>(
      value: _currentMapType,
      items: [
        const DropdownMenuItem<MapType>(
          value: MapType.normal,
          child: Text('Normal'),
        ),
        const DropdownMenuItem<MapType>(
          value: MapType.satellite,
          child: Text('Satellite'),
        ),
        const DropdownMenuItem<MapType>(
          value: MapType.hybrid,
          child: Text('Hybrid'),
        ),
        const DropdownMenuItem<MapType>(
          value: MapType.terrain,
          child: Text('Terrain'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _currentMapType = value!;
        });
      },
    );
  }
}

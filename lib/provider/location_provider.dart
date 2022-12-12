import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/displayvideo/v1.dart';
import 'package:location/location.dart';
import 'package:tfg_proyect/models/Posicion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/models/Posicion.dart';
import 'package:tfg_proyect/provider/location_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor? _pinLocationIcon;
  Map<MarkerId, Marker>? _markers;
  Map<MarkerId, Marker> get markers => _markers!;
  final MarkerId markerPetId = MarkerId("1");

  GoogleMapController? _mapController;
  GoogleMapController get mapController => _mapController!;

  Location? _location;
  Location get location => _location!;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon!;

  LatLng? _locationPosition;
  LatLng get locationPosition => _locationPosition!;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
    _markers = <MarkerId, Marker>{};
  }

  Future<List<Posicion>>? _listaPosicionesFuture;

  initialization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  testTime() {}

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        Posicion uno = Posicion(36.69821147816643, -6.123170805604833);
        Posicion dos = Posicion(36.699073267573176, -6.124276986961624);
        Posicion tres = Posicion(36.69863649505223, -6.1251634845442124);

        List<Posicion> listaPosicionesEstatica = [uno, dos, tres];
        Marker marker;
        marker = Marker(
          markerId: markerPetId,
          position: LatLng(
            listaPosicionesEstatica[0].latitud,
            listaPosicionesEstatica[0].longitud,
          ),
          icon: pinLocationIcon,
        );
        _markers![markerPetId] = marker;
        notifyListeners();
        print("Posicion del marcador");
        print("++++++++++++++++++++++++++++++++++++++++++++++");
        print(marker.position);
        notifyListeners();
      },
    );
  }

  setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/imagenes/huellaPerroMapa.png',
    );
  }

  takeSnapshot() {
    return _mapController!.takeSnapshot();
  }
}

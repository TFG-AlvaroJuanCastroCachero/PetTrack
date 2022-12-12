import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/models/Posicion.dart';
import 'package:tfg_proyect/pages/mapa_controller.dart';
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
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';

class PaginaMapa extends StatefulWidget {
  PaginaMapa({Key? key}) : super(key: key);

  @override
  _PaginaMapaState createState() => _PaginaMapaState();
}

class _PaginaMapaState extends State<PaginaMapa> {
  final referenceDatabase = FirebaseDatabase.instance.reference();
  var _controller = MapaController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapaController>(
      create: (_) => MapaController(),
      child: Scaffold(
        body: Consumer<MapaController>(
          builder: (_, controller, __) => GoogleMap(
            onMapCreated: controller.onMapCreated,
            onTap: controller.onTap,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: controller.initialLocation,
            markers: controller.markersGet,
          ),
        ),
      ),
    );
  }
}

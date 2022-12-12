import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tfg_proyect/models/Posicion.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:vector_math/vector_math.dart' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class MapaController extends ChangeNotifier {
  final Map<MarkerId, Marker> markers = {};
  final MarkerId markerPet = MarkerId("pet");
  Future<List<Posicion>>? _listaPosicionesFuture;
  var item = 0;
  GoogleMapController? controller;
  final database = FirebaseDatabase.instance.reference();
  final User? user = FirebaseAuth.instance.currentUser;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Set<Marker> get markersGet => markers.values.toSet();

  final CameraPosition initialLocation = const CameraPosition(
    target: LatLng(36.69821880889666, -6.125665986081684),
    zoom: 16,
  );

  Timer? timer;

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    String formatted = formatter.format(now);
    print("Fecha actual: " + formatted);
    int radiusEarth = 6371;
    double distanceKm;
    double distanceMts;
    double dlat, dlng;
    double a;
    double c;

    //Convertimos de grados a radianes
    lat1 = math.radians(lat1);
    lat2 = math.radians(lat2);
    lng1 = math.radians(lng1);
    lng2 = math.radians(lng2);
    // Fórmula del semiverseno
    dlat = lat2 - lat1;
    dlng = lng2 - lng1;
    a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * (sin(dlng / 2)) * (sin(dlng / 2));
    c = 2 * atan2(sqrt(a), sqrt(1 - a));

    distanceKm = radiusEarth * c;
    print('Distancia en Kilométros:$distanceKm');
    distanceMts = 1000 * distanceKm;
    print('Distancia en Metros:$distanceMts');
    var pasos = 0.0;
    pasos = distanceKm * 100000 / 70;
    print("pasos: $pasos");
    // paso * long / 100.000 = km
    // km * 100.000 / long

    // CALORÍAS= DISTANCIA en kilómetros x PESO en kilogramos x FACTOR CORRER (1,036)
    // Si vamos a andar en vez de correr, el FACTOR ANDAR es 0,73 calorías por kilo, ya que se gastan menos calorías andando que corriendo.
    var calorias = 0.0;
    calorias = distanceKm * 10 * 0.73;
    print("calorías gastadas: $calorias");

    var fecha = formatted.split("-");
    print("fecha 12341234: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];

    var anoMes = ano + mes;

    print("ano: $ano");
    print("mes: $mes");
    print("dia: $dia");

    database
        .child("Usuario")
        .child(user!.uid)
        .child('fechaDist')
        .child(anoMes)
        .child(dia)
        .set(distanceKm);

    return distanceKm;
    //return distanceMts;
  }

  void onMapCreated(GoogleMapController? controller) async {
    _listaPosicionesFuture = _getPosicion();
    List<Posicion>? _listaP = await _listaPosicionesFuture;
    // print("lista marcadores OnMapCreate antes: $markers");
    markers[markerPet] = Marker(
      markerId: markerPet,
      position: LatLng(_listaP![item].latitud, _listaP[item].longitud),
    );
    print("lista marcadores OnMapCreate despues: $markers");

    notifyListeners();
  }

  Future<List<Posicion>> _getPosicion() async {
    final response = await http
        .get(Uri.parse("https://api-gps-pettrack.ew.r.appspot.com/positions"));
    // .get(Uri.parse("https://pettrack-v1.herokuapp.com/positions"));

    List<Posicion> posiciones = [];

    if (response.statusCode == 200) {
      // print(response.body);
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      // print(jsonData[0]["longitud"]);

      for (var item in jsonData) {
        posiciones.add(Posicion(
            double.parse(item["latitud"]), double.parse(item["longitud"])));
      }
      return posiciones;
    } else {
      throw Exception("Fallo la conexión");
    }
  }

  void getPositionPet() async {
    _listaPosicionesFuture = _getPosicion();
    List<Posicion>? _listaP = await _listaPosicionesFuture;
    if (item < _listaP!.length - 1) {
      item++;
    }
    // print("listaPosicionesAPI: $_listaP");
    final marker = Marker(
      markerId: markerPet,
      position: LatLng(_listaP[item].latitud, _listaP[item].longitud),
      // position: position,
    );
    // print("posicion $item del marcador $marker.position");
    markers[markerPet] = marker;
    // print("lista marcadores $markers");
    notifyListeners();
  }

  void onTap(LatLng position) async {
    _listaPosicionesFuture = _getPosicion();
    List<Posicion>? _listaP = await _listaPosicionesFuture;
    if (item < _listaP!.length - 1) {
      item++;
    }
    if (item > 0) {
      var distancia = calculateDistance(
          _listaP[item].latitud,
          _listaP[item].longitud,
          _listaP[item - 1].latitud,
          _listaP[item - 1].longitud);
      String distanciaToS = distancia.toString();
      print("kilometros entre las coordenadas: $distanciaToS");
    }

    final marker = Marker(
      markerId: markerPet,
      position: LatLng(_listaP[item].latitud, _listaP[item].longitud),
    );
    markers[markerPet] = marker;
    notifyListeners();
  }

  void upDateMarkers() {
    print("lista marcadores $markers");
  }
}

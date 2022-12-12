import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:googleapis/calendar/v3.dart';
import 'package:tfg_proyect/models/event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tfg_proyect/models/event.dart';
import "package:http/http.dart" as http;
import "package:googleapis_auth/auth_io.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:googleapis/calendar/v3.dart' as googleAPI;
import 'package:http/io_client.dart';
import 'package:http/http.dart';
// import 'package:google_sign_in/google_sign_in.dart'
//     show GoogleSignIn, GoogleSignInAccount;
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:tfg_proyect/models/event.dart';
import 'package:tfg_proyect/pages/EventEditingPage.dart';
import 'package:tfg_proyect/provider/event_provider.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class CalendarClient extends CalendarDataSource {
  static const _scopes = const [googleAPI.CalendarApi.calendarScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    clientId:
        '763462296644-a66q2s6v2h2k9ljs8604ka0ao97fo81d.apps.googleusercontent.com',
    scopes: <String>[
      googleAPI.CalendarApi.calendarScope,
    ],
  );

  insert(title, startTime, endTime) async {
    print("ANTES DE INICIO DE SESION");
    try {
      print("calendarScope");
      print(googleAPI.CalendarApi.calendarScope);

      await _googleSignIn.signIn();
      var httpClient = (await _googleSignIn.authenticatedClient())!;
      final googleAPI.CalendarApi calendarAPI =
          googleAPI.CalendarApi(httpClient);
      String calendarId = "primary";

      googleAPI.Event event = googleAPI.Event(); // Create object of event

      event.summary = title;

      googleAPI.EventDateTime start = new googleAPI.EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+02:00";
      event.start = start;

      googleAPI.EventDateTime end = new googleAPI.EventDateTime();
      end.timeZone = "GMT+02:00";
      end.dateTime = endTime;
      event.end = end;

      try {
        print("estoy dentro del mdfk try para insertar");
        calendarAPI.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      } catch (e) {
        log('Error creating event $e');
      }
    } catch (error) {
      print(error);
    }
    print("INICIO DE SESION");
  }
}

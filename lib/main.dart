// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/auth/AuthenticationWrapper.dart';
import 'package:tfg_proyect/pages/PaginaMapa.dart';
import 'package:tfg_proyect/provider/event_provider.dart';
import 'package:tfg_proyect/provider/location_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/Authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<int>('steps');
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: PaginaMapa(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => EventProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TFG proyect',
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.teal[300]),
          ),
          home: AuthenticationWrapper(),
        ),
      ),
    );
  }
}

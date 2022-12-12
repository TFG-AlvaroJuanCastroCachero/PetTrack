import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class PaginaEstadisticas extends StatefulWidget {
  @override
  _PaginaEstadisticasState createState() => _PaginaEstadisticasState();
}

class _PaginaEstadisticasState extends State<PaginaEstadisticas> {
  final database = FirebaseDatabase.instance.reference();
  final User? user = FirebaseAuth.instance.currentUser;
  final DateTime hoy = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<Walks> dataBarchar = [
    Walks("mon", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("tue", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("wed", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("thur", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("fri", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("sat", 0, charts.ColorUtil.fromDartColor(Colors.black)),
    Walks("sun", 0, charts.ColorUtil.fromDartColor(Colors.black)),
  ];

  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  var distanceKmBBDD = 0.0;
  var walktimer = "00:00:00";
  var calories = "";
  var pasos = "";
  String userPetName = "";
  // var hours = "00";
  // var minutes = "00";
  // var seconds = "00";
  var valuesMap = SplayTreeMap<String, double>();
  // String horas = "";
  // String minutos = "";
  // String segundos = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234 intState: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];
    var anoMes = ano + mes;
    Map<dynamic, dynamic>? infobbdd;
    Map<dynamic, dynamic>? anoMesExiste;

    database
        .child('Usuario')
        .child(user!.uid)
        .once()
        .then((DatabaseEvent databbdd) {
      DataSnapshot dataSnapshot = databbdd.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map;
      // Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, value) {
        if (key == 'PetName') {
          userPetName = value;
          print(userPetName);
        }
      });

      setState(() {});
    });

    database.child("Usuario").child(user!.uid).once().then((event) {
      DataSnapshot snapshot = event.snapshot;
      // print("snapshot: " + snapshot.toString());
      infobbdd = snapshot.value as Map;

      print("infobbdd: $infobbdd");
      if (infobbdd!.containsKey("fechaDist")) {
        database
            .child("Usuario")
            .child(user!.uid)
            .child('fechaDist')
            .once()
            .then((event) {
          DataSnapshot snapshot = event.snapshot;
          anoMesExiste = snapshot.value as Map;
          print("anoMesExiste: $anoMesExiste");
          if (anoMesExiste!.containsKey(anoMes)) {
            database
                .child("Usuario")
                .child(user!.uid)
                .child('fechaDist')
                .child(anoMes)
                .once()
                .then((event) {
              DataSnapshot snapshot = event.snapshot;
              Map<dynamic, dynamic>? values = snapshot.value as Map;

              print("values bbdd: $values");
              values.forEach((key, value) {
                if (key == "timer") {
                } else {
                  valuesMap[key] = value.toDouble();
                  if (key == dia) {
                    distanceKmBBDD = value.toDouble();
                    print("distanceKmBBDD intState: $distanceKmBBDD");
                  }
                }
              });
              print("valuesMap SplayTreeMap initState: $valuesMap");
              bottonDay();
              monthlyTimer();
            });
          } else {
            database
                .child("Usuario")
                .child(user!.uid)
                .child('fechaDist')
                .child(anoMes)
                .child(dia)
                .set(0.0);

            database
                .child("Usuario")
                .child(user!.uid)
                .child('fechaDist')
                .child(anoMes)
                .child('timer')
                .set('00:00:00');

            distanceKmBBDD = 0.0;
            print("distanceKmBBDD intState: $distanceKmBBDD");
            bottonDay();
            monthlyTimer();
          }
        });
      } else {
        database
            .child("Usuario")
            .child(user!.uid)
            .child('fechaDist')
            .child(anoMes)
            .child(dia)
            .set(0.0);

        database
            .child("Usuario")
            .child(user!.uid)
            .child('fechaDist')
            .child(anoMes)
            .child('timer')
            .set('00:00:00');

        distanceKmBBDD = 0.0;
        print("distanceKmBBDD intState: $distanceKmBBDD");
        bottonDay();
        monthlyTimer();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Walks>> calcularPasosDiaBarchar(dataBarchar) async {
    int i = 1;
    print("hoy que día es: $hoy");
    int diaSemana = hoy.weekday;
    // i = diaSemana;
    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234 calcularPasosDiaBarchar: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];
    var anoMes = ano + mes;
    var res = 0;

    print("map de valores ordenados calcularBarchar1: $valuesMap");
    print("dia de la semana: $diaSemana");
    print("valuesMap: $valuesMap");
    switch (diaSemana) {
      case 1:
        {
          valuesMap.forEach((key, value) {
            if (key == dia) {
              var pasos = value * 100000 / 70;
              dataBarchar[0].steps = pasos.round();
            }
          });
        }
        break;
      case 2:
        {
          print("BARCHAR entre en 2");

          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 2) {
              res = 2 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            if (valuesMap.length > 2 && i >= (valuesMap.length - 1)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
      case 3:
        {
          print("BARCHAR entre en 3");

          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 3) {
              res = 3 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            if (valuesMap.length > 3 && i >= (valuesMap.length - 2)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
      case 4:
        {
          print("BARCHAR entre en 4");

          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 4) {
              res = 4 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            if (valuesMap.length > 4 && i >= (valuesMap.length - 3)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
      case 5:
        {
          print("BARCHAR entre en 5");
          print("vaulesMap 5 viernes: $valuesMap");

          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 5) {
              res = 5 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            if (valuesMap.length > 5 && i >= (valuesMap.length - 4)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
      case 6:
        {
          print("BARCHAR entre en 6");

          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 6) {
              res = 6 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            if (valuesMap.length > 6 && i >= (valuesMap.length - 5)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
      case 7:
        {
          print("BARCHAR entre en 7");
          valuesMap.forEach((key, value) {
            if (valuesMap.length <= 7) {
              res = 7 - valuesMap.length;
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
            }
            if (valuesMap.length > 7 && i >= (valuesMap.length - 6)) {
              var pasos = value * 100000 / 70;
              dataBarchar[res].steps = pasos.round();
              res++;
            }
            i++;
          });
        }
        break;
    }

    return dataBarchar;
  }

  Widget barchartSteps(context) {
    print("barchartSteps context: $context");
    print("data[1] dia: " + dataBarchar[1].day.toString());

    calcularPasosDiaBarchar(dataBarchar);
    int diaSemana = hoy.weekday;
    print("dia de la semana: $diaSemana");

    final size = MediaQuery.of(context).size;
    print("barchar size por context: $size");

    List<charts.Series<Walks, String>> series = [
      charts.Series(
          id: "Walks",
          data: dataBarchar,
          domainFn: (Walks series, _) => series.day,
          measureFn: (Walks series, _) => series.steps,
          colorFn: (Walks series, _) => series.barColor)
    ];

    return Container(
      height: size.height * 0.35,
      padding: EdgeInsets.all(size.height * 0.02),
      child: Column(
        children: [
          Text(
            'Steps per day',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.03,
            ),
          ),
          Expanded(
            child: charts.BarChart(series, animate: true),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    print("build size por context: $size");
    return ListView(
      padding: EdgeInsets.all(size.height * 0.02),
      children: [
        petName(context),
        dateRow(context),
        walkerTimeResumen(context),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.teal,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              paseo(context),
              walkerTime(context),
              buildWalkButtons(context),
            ],
          ),
        ),
        // totalSteps(context),
        barchartSteps(context),
        Padding(padding: EdgeInsets.all(size.height * 0.01)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.teal,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              activeRestTime(context),
              activeRestTimeNumbers(context),
              Padding(padding: EdgeInsets.all(size.height * 0.01)),
              distance(context),
              distancekm(context),
              Padding(padding: EdgeInsets.all(size.height * 0.01)),
              buildIcons(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget paseo(context) {
    final size = MediaQuery.of(context).size;

    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Walk timer",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget petName(context) {
    final size = MediaQuery.of(context).size;

    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userPetName.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  void bottonDay() async {
    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];

    var anoMes = ano + mes;
    DatabaseEvent databbdd = await database
        .child("Usuario")
        .child(user!.uid)
        .child('fechaDist')
        .child(anoMes)
        .orderByKey()
        // .child(dia)
        .once();
    DataSnapshot dataSnapshot = databbdd.snapshot;
    Map<dynamic, dynamic>? values = dataSnapshot.value as Map;
    // var valuesMap = SplayTreeMap<String, double>();
    print("values bbdd: $values");
    values.forEach((key, value) {
      // valuesMap[key] = value;
      if (key == "timer") {
      } else {
        print("key BBDD: $key");
        if (key == dia) {
          distanceKmBBDD = value.toDouble();
          print("distanceKmBBDD1: " + distanceKmBBDD.toString());
        }
      }
    });

    setState(() {
      activeRestTimeNumbers(context);
    });

    print("calorias bbdd: $calories");
    print("pasos bbdd:" + pasos);
  }

  Widget buildIcons(context) {
    final size = MediaQuery.of(context).size;
    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];

    var anoMes = ano + mes;
    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            bottonDay();
          },
          child: Text("Day",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              )),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.teal,
            onSurface: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: () async {
            distanceKmBBDD = 0.0;

            DatabaseEvent databbdd = await database
                .child("Usuario")
                .child(user!.uid)
                .child('fechaDist')
                .child(anoMes)
                .orderByKey()
                // .child(dia)
                .once();

            DataSnapshot dataSnapshot = databbdd.snapshot;
            Map<dynamic, dynamic>? values = dataSnapshot.value as Map;

            var valuesMap = SplayTreeMap<String, double>();
            int lengthMap = values.length;
            print("no funciona??");
            print("long map: $lengthMap");
            print("mapa de valores bbdd: $values");
            int i = 0;
            values.forEach((key, value) {
              if (key == "timer") {
              } else {
                valuesMap[key] = value;
                print("key BBDD: $key");
              }
            });
            print("valuesMap SplayTreeMap: $valuesMap");
            valuesMap.forEach((key, value) {
              i++;
              print("i: $i");
              print("values (distancia por día) : $value");
              if (lengthMap <= 7) {
                print("menos de 7 días");
                distanceKmBBDD = distanceKmBBDD + value;
                print("distanceKmBBDD1: " + distanceKmBBDD.toString());
              }
              if (lengthMap > 7 && i >= (lengthMap - 7)) {
                print("mas de 7 días pero termina entrando cuando i vale: $i");
                distanceKmBBDD = distanceKmBBDD + value;
                print("distanceKmBBDD1: " + distanceKmBBDD.toString());
              }
            });

            setState(() {
              activeRestTimeNumbers(context);
            });

            print("calorias bbdd: $calories");
            print("pasos bbdd:" + pasos);
          },
          child: Text(" Week ",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              )),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.teal,
            onSurface: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: () async {
            distanceKmBBDD = 0.0;

            DatabaseEvent databbdd = await database
                .child("Usuario")
                .child(user!.uid)
                .child('fechaDist')
                .child(anoMes)
                .orderByKey()
                // .child(dia)
                .once();

            DataSnapshot dataSnapshot = databbdd.snapshot;
            Map<dynamic, dynamic>? values = dataSnapshot.value as Map;
            var valuesMap = SplayTreeMap<String, double>();
            int lengthMap = values.length;
            print("long map: $lengthMap");
            print("mapa de valores bbdd: $values");
            int i = 0;
            values.forEach((key, value) {
              if (key == "timer") {
              } else {
                valuesMap[key] = value;
                print("key BBDD: $key");
              }
            });
            print("valuesMap SplayTreeMap: $valuesMap");
            valuesMap.forEach((key, value) {
              i++;
              print("i: $i");
              print("values (distancia por día) : $value");
              distanceKmBBDD = distanceKmBBDD + value;
            });

            setState(() {
              activeRestTimeNumbers(context);
            });

            print("calorias bbdd: $calories");
            print("pasos bbdd:" + pasos);
          },
          child: Text("Month",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              )),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.teal,
            onSurface: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal[200],
      ),
      padding: EdgeInsets.all(18),
      child: child,
    );
  }

  Widget dateRow(context) {
    final size = MediaQuery.of(context).size;
    var todayDay = DateTime.now().day;
    String todayDayString = todayDay.toString();
    if (todayDay < 10) {
      todayDayString = "0" + todayDayString;
    }
    var todayMonth = DateTime.now().month;
    String todayMonthString = todayMonth.toString();
    if (todayMonth < 10) {
      todayMonthString = "0" + todayMonthString;
    }
    var todayYear = DateTime.now().year;
    return Container(
      // color: Colors.black,
      padding: EdgeInsets.fromLTRB(size.height * 0.0, size.height * 0.025,
          size.height * 0, size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(padding: EdgeInsets.all(30)),
          Text(
              todayDayString +
                  "/" +
                  todayMonthString +
                  "/" +
                  todayYear.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: size.height * 0.03,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget gradientShaderMask({required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.orange,
          Colors.deepOrange.shade900,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  Duration duration = Duration();

  Timer? timer;

  void addTimer() {
    final addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
      });
    }
  }

  //Timer -> cada 1 segundo está llamando a la función addTimer() -> se puede usar para los valores de la API
  //para cancelar el timer y sus continuas llamadas -> timer?.cancel()
  var item = 0;
  Future<String> startTimerCall(item) async {
    startTimer();
    item++;
    print("prueba y error num: $item");
    return "prueba y error num: $item";
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    if (mounted) {
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTimer());
    }
  }

  void reset() {
    if (mounted) {
      setState(() {
        duration = Duration();
        timer?.cancel();
      });
    }
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    if (mounted) {
      setState(() {
        timer?.cancel();
      });
    }
  }

  Widget walkerTimeResumen(context) {
    final size = MediaQuery.of(context).size;

    List<String> splitTime = walktimer.split(":");
    String horasT = splitTime[0];
    String minutosT = splitTime[1];
    String segundosT = splitTime[2];

    print("hour: $horasT");
    print("minute: $minutosT");
    print("second: $segundosT");
    String horaTimer = horasT;
    String minuteTimer = minutosT;
    String secondTimer = segundosT;
    return Container(
      padding: EdgeInsets.all(size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Monthly walk timer: $horaTimer:$minuteTimer:$secondTimer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget walkerTime(context) {
    final size = MediaQuery.of(context).size;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
      padding: EdgeInsets.all(size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$hours:$minutes:$seconds',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  void monthlyTimer() async {
    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];

    var anoMes = ano + mes;
    DatabaseEvent databbdd = await database
        .child("Usuario")
        .child(user!.uid)
        .child('fechaDist')
        .child(anoMes)
        .child('timer')
        .once();

    DataSnapshot dataSnapshot = databbdd.snapshot;
    print("dataSnapshot: ");
    print(dataSnapshot.value);

    walktimer = dataSnapshot.value as String;
    print("finish timer monthly: $walktimer");
    List<String> splitTime = walktimer.split(":");
    String horas = splitTime[0];
    String minutos = splitTime[1];
    String segundos = splitTime[2];

    setState(() {
      walkerTimeResumen(context);
    });
  }

  finishAddTimer() async {
    Map<dynamic, dynamic> anoMesExiste;
    String formatted = formatter.format(hoy);
    var fecha = formatted.split("-");
    print("fecha 12341234 intState: $fecha");
    var ano = fecha[0];
    var mes = fecha[1];
    var dia = fecha[2];
    var anoMes = ano + mes;

    DatabaseEvent databbdd = await database
        .child("Usuario")
        .child(user!.uid)
        .child('fechaDist')
        .child(anoMes)
        .child('timer')
        .once();

    String time = databbdd.snapshot.value as String;

    print("finish timer func: $time");
    print("finish duration func: $duration");

    var timerSplit = time.split(":");
    print("timerSplit: " + timerSplit.toString());

    var timeDuration = Duration(
      hours: int.parse(timerSplit[0]),
      minutes: int.parse(timerSplit[1]),
      seconds: int.parse(timerSplit[2]),
    );

    time = (timeDuration + duration).toString();
    print("finish timer after func: $time");
    var timerSplitFinal = time.split(".");

    print("time después de sumar durations: " + timerSplitFinal[0]);

    database
        .child("Usuario")
        .child(user!.uid)
        .child('fechaDist')
        .child(anoMes)
        .child('timer')
        .set(timerSplitFinal[0]);

    monthlyTimer();

    reset();
  }

  Widget buildWalkButtons(context) {
    final size = MediaQuery.of(context).size;
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                    // print(await compute(startTimerCall, "null"));
                  }
                },
                child: Text(isRunning ? "Stop the walk" : "Resume the walk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.bold,
                    )),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.black,
                  onSurface: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () async {
                  finishAddTimer();
                },
                child: Text("Finish the walk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.bold,
                    )),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.black,
                  onSurface: Colors.grey,
                ),
              ),
            ],
          )
        : TextButton(
            onPressed: () {
              startTimer();
            },
            child: Text("Start the walk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.bold,
                )),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.black,
              onSurface: Colors.grey,
            ),
          );
  }

  Widget activeRestTime(context) {
    final size = MediaQuery.of(context).size;
    // print("distancia en active: $distanceKmBBDD");
    // var calories = calculaCalorias(distanceKmBBDD);
    // print("calorias bbdd: $calories");

    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Padding(padding: EdgeInsets.all(30)),
          Text(
            "Calories",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.height * 0.028),
          ),
          Text(
            "Steps",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.height * 0.028),
          ),
        ],
      ),
    );
  }

  // var calories = 0.0;
  // var steps = 0;

  String calculaCalorias(distanceKmBBDD) {
    print("distancia en calculaCalo: $distanceKmBBDD");
    var distanciaCalorias = distanceKmBBDD;
    print("calcula distancia caloria: " + distanciaCalorias.toString());
    if (distanciaCalorias == null) {
      distanciaCalorias = 0.0;
    }
    var calorias = distanciaCalorias * 10 * 0.8;
    // var calorias =
    //     0.0215 * pow(5, 3) - 0.1765 * pow(5, 2) + 0.8710 * 5 + 1.4577 * 10 * 1;
    int s = calorias.floor();
    print("flooooor: $s");
    var caloDecimal = calorias.toStringAsFixed(2);
    print("caloDecimaaal: $caloDecimal");
    String caloriestoString = caloDecimal.toString();
    return caloriestoString;
  }

  String calculaPasos(distanceKmBBDD) {
    var pasos = distanceKmBBDD;
    if (pasos == null) {
      pasos = 0.0;
    }
    pasos = distanceKmBBDD * 100000 / 70;
    var pasosDecimal = pasos.toStringAsFixed(2);
    var pasostoString = pasosDecimal.toString();
    print("pasos: $pasostoString");
    return pasostoString;
  }

  Widget activeRestTimeNumbers(context) {
    final size = MediaQuery.of(context).size;
    print("distanceKmBBDD para calcular calories y peso: $distanceKmBBDD");
    calories = calculaCalorias(distanceKmBBDD);
    print("calorias bbdd: $calories");

    pasos = calculaPasos(distanceKmBBDD);
    print("pasos bbdd:" + pasos);

    return Container(
      // color: Colors.black,
      padding: EdgeInsets.fromLTRB(size.width * 0.04, 0, 0, 0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(size.width * 0.04, 0, 0, 0)),
          // Icon(Icons.wb_sunny),
          Icon(Icons.local_fire_department),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.01, 0, size.height * 0.02, 0)),
          Text(
            calories,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.028,
                color: Colors.teal[400]),
          ),
          Padding(padding: EdgeInsets.fromLTRB(size.width * 0.23, 0, 0, 0)),
          // Icon(Icons.bedtime),
          Icon(Icons.pets),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  size.height * 0.01, 0, size.height * 0.01, 0)),
          Text(
            pasos,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.028,
                color: Colors.teal[400]),
          ),
        ],
      ),
    );
  }

  Widget distance(context) {
    final size = MediaQuery.of(context).size;

    return Container(
      // color: Colors.black,
      // padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Padding(padding: EdgeInsets.all(30)),
          Text(
            "Distance",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.height * 0.028),
          ),
        ],
      ),
    );
  }

  Widget distancekm(context) {
    final size = MediaQuery.of(context).size;
    var dist = distanceKmBBDD;
    var distDecimal = dist.toStringAsFixed(3);
    var disttoString = distDecimal.toString();

    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Padding(padding: EdgeInsets.all(30)),
          Text(
            disttoString + " km",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.028,
                color: Colors.teal[400]),
          ),
        ],
      ),
    );
  }
}

class Walks {
  late String day;
  late int steps;
  late charts.Color barColor;

  // Walks({required this.day, required this.steps, required this.barColor});

  Walks(day, steps, barColor) {
    this.day = day;
    this.steps = steps;
    this.barColor = barColor;
  }
}

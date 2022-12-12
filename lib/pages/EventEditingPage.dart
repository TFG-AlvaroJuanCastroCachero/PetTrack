import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/Utils.dart';
import 'package:tfg_proyect/models/event.dart';
import 'package:tfg_proyect/provider/event_provider.dart';
import 'package:tfg_proyect/pages/CalendarInsert.dart';

class EventEditingPage extends StatefulWidget {
  final EventCalendar? event;
  // final EventCalendar event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  final User? user = FirebaseAuth.instance.currentUser;
  late DateTime fromDate;
  late DateTime toDate;
  CalendarClient calendarClient = CalendarClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 1));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          leading: CloseButton(),
          actions: buildEditingActions(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePickers(),
              ],
            ),
          ),
        ));
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal[400],
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(Icons.done),
          label: Text("Save"),
        ),
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 25),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => builHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onclicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onclicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildTo() => builHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(toDate),
                onclicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onclicked: () => pickToDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildDropdownField(
          {required String text, required VoidCallback onclicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onclicked,
      );

  Widget builHeader({required String header, required Row child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
          child,
        ],
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour + 1, date.minute);
    }

    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    if (date.isBefore(fromDate)) {
      fromDate =
          DateTime(date.year, date.month, date.day, date.hour - 1, date.minute);
    }

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formkey.currentState!.validate();

    if (isValid) {
      final event = EventCalendar(
        title: titleController.text,
        description: 'Descripcion',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);

        Navigator.of(context).pop();
      } else {
        print("AAAAAAAAAAAAAAAA");
        calendarClient.insert(
          event.title,
          event.from,
          event.to,
        );
        print("entro?");
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/common/loader.dart';
import '../../../core/utils/notification_service.dart';
import '../../../models/prescription_model.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  List<PrescriptionEvent> firestoreEvents = []; // Declare it here

  Future<void> addEventToFirestore(PrescriptionEvent event) async {
    try {
      await FirebaseFirestore.instance
          .collection('prescription')
          .doc(event.id)
          .set(event.toMap());
    } catch (e) {
      print('Error adding Prescription event: $e');
    }
  }

  Future<void> deleteEventFromFirestore(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('prescription')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error removing Appointment : $e');
    }
  }

  Stream<List<PrescriptionEvent>> getEventsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('prescription')
        .snapshots()
        .map(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map(
          (QueryDocumentSnapshot doc) {
            return PrescriptionEvent.fromMap(
                doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  List _listOfDayEvents(DateTime dateTime, List<PrescriptionEvent> events) {
    final selectedDateEvents = events
        .where((event) =>
            DateFormat('yyyy-MM-dd').format(event.timestamp.toDate()) ==
            DateFormat('yyyy-MM-dd').format(dateTime))
        .toList();

    return selectedDateEvents;
  }

  _showAddEventDialog() async {
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Add Event'),
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Required title and description'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                setState(() {
                  final DateTime selectedDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  final eventId = Uuid().v1();
                  PrescriptionEvent newEvent = PrescriptionEvent(
                    id: eventId,
                    eventTitle: titleController.text,
                    eventDescp: descpController.text,
                    timestamp: Timestamp.fromDate(selectedDateTime),
                  );

                  // Add the event to Firestore
                  addEventToFirestore(newEvent);
                  NotificationService().scheduleNotification(
                      title: titleController.text,
                      body: descpController.text,
                      scheduledNotificationDateTime: selectedDateTime);
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(selectedDateTime)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(selectedDateTime)]
                        ?.add({
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                      "time": selectedTime!.format(context),
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(selectedDateTime)] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                        "time": selectedTime!.format(context),
                      }
                    ];
                  }
                });

                print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");
                titleController.clear();
                descpController.clear();
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prescription Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2022),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (dateTime) =>
                _listOfDayEvents(dateTime, firestoreEvents),
          ),
          Expanded(
            child: StreamBuilder<List<PrescriptionEvent>>(
              stream: getEventsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  firestoreEvents = snapshot.data!;
                  List<PrescriptionEvent> selectedDateEvents = firestoreEvents
                      .where((event) =>
                          DateFormat('yyyy-MM-dd')
                              .format(event.timestamp.toDate()) ==
                          DateFormat('yyyy-MM-dd').format(_selectedDate!))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedDateEvents.length,
                    itemBuilder: (context, index) {
                      final firestoreEvent = selectedDateEvents[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Event Title: ${firestoreEvent.eventTitle}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Description: ${firestoreEvent.eventDescp}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Time: ${DateFormat('hh:mm a, MMM dd, yyyy').format(firestoreEvent.timestamp.toDate())}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () =>
                                  deleteEventFromFirestore(firestoreEvent.id),
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Event'),
      ),
    );
  }
}

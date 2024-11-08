// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionEvent {
  final String id;
  final String eventTitle;
  final String eventDescp;
  final Timestamp timestamp;
  PrescriptionEvent({
    required this.id,
    required this.eventTitle,
    required this.eventDescp,
    required this.timestamp,
  });

  PrescriptionEvent copyWith({
    String? id,
    String? eventTitle,
    String? eventDescp,
    Timestamp? timestamp,
  }) {
    return PrescriptionEvent(
      id: id ?? this.id,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDescp: eventDescp ?? this.eventDescp,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventTitle': eventTitle,
      'eventDescp': eventDescp,
      'timestamp': timestamp,
    };
  }

  factory PrescriptionEvent.fromMap(Map<String, dynamic> map) {
    return PrescriptionEvent(
      id: map['id'] as String,
      eventTitle: map['eventTitle'] as String,
      eventDescp: map['eventDescp'] as String,
      timestamp: (map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrescriptionEvent.fromJson(String source) =>
      PrescriptionEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PrescriptionEvent(eventTitle: $eventTitle, eventDescp: $eventDescp, timestamp: $timestamp)';

  @override
  bool operator ==(covariant PrescriptionEvent other) {
    if (identical(this, other)) return true;

    return other.eventTitle == eventTitle &&
        other.eventDescp == eventDescp &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      eventTitle.hashCode ^ eventDescp.hashCode ^ timestamp.hashCode;
}

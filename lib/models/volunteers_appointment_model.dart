// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteersAppointmentModel {
  final String reason;
  final String id;
  final String userId;
  final bool isAccepted;
  final Timestamp appointmentTime;
  VolunteersAppointmentModel({
    required this.reason,
    required this.userId,
    required this.id,
    required this.isAccepted,
    required this.appointmentTime,
  });

  VolunteersAppointmentModel copyWith({
    String? reason,
    String? id,
    String? userId,
    bool? isAccepted,
    Timestamp? appointmentTime,
  }) {
    return VolunteersAppointmentModel(
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      isAccepted: isAccepted ?? this.isAccepted,
      appointmentTime: appointmentTime ?? this.appointmentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reason': reason,
      'id': id,
      'isAccepted': isAccepted,
      'userId': userId,
      'appointmentTime': appointmentTime,
    };
  }

  factory VolunteersAppointmentModel.fromMap(Map<String, dynamic> map) {
    return VolunteersAppointmentModel(
      reason: map['reason'] as String,
      id: map['id'] as String,
      userId: map['userId'] as String,
      isAccepted: map['isAccepted'] ,
      appointmentTime: map['appointmentTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VolunteersAppointmentModel.fromJson(String source) =>
      VolunteersAppointmentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'VolunteersAppointmentModel(reason: $reason, id: $id, appointmentTime: $appointmentTime)';

  @override
  bool operator ==(covariant VolunteersAppointmentModel other) {
    if (identical(this, other)) return true;

    return other.reason == reason &&
        other.id == id &&
        other.appointmentTime == appointmentTime;
  }

  @override
  int get hashCode => reason.hashCode ^ id.hashCode ^ appointmentTime.hashCode;
}

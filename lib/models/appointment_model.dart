// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String title;

  final String desc;
  final String userId;
  final Timestamp timestamp;
  AppointmentModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.userId,
    required this.timestamp,
  });

  AppointmentModel copyWith({
    String? id,
    String? title,
    String? desc,
    String? userId,
    Timestamp? timestamp,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      desc: desc ?? this.desc,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'userId': userId,
      'timestamp': timestamp,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      userId: map['userId'] as String,
      desc: map['desc'] as String,
      timestamp: (map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppointmentModel(title: $title, desc: $desc, timestamp: $timestamp)';

  @override
  bool operator ==(covariant AppointmentModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.desc == desc &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => title.hashCode ^ desc.hashCode ^ timestamp.hashCode;
}

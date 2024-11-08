// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String document;
  final Timestamp createdOn;
  final Timestamp lastEdit;
  DocumentModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.document,
    required this.createdOn,
    required this.lastEdit,
  });

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? document,
    Timestamp? createdOn,
    Timestamp? lastEdit,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      document: document ?? this.document,
      createdOn: createdOn ?? this.createdOn,
      lastEdit: lastEdit ?? this.lastEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'document': document,
      'createdOn': createdOn,
      'lastEdit': lastEdit,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      document: map['document'] as String,
      createdOn: map['createdOn'],
      lastEdit: map['lastEdit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(title: $title, description: $description, document: $document, createdOn: $createdOn, lastEdit: $lastEdit)';
  }

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.document == document &&
        other.createdOn == createdOn &&
        other.lastEdit == lastEdit;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        document.hashCode ^
        createdOn.hashCode ^
        lastEdit.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String admin;
  final String groupIcon;
  final String name;
  final List<String> members;
  final String recentMessage;
  final Map<String, String> kickedMembers;
  Community({
    required this.id,
    required this.admin,
    required this.groupIcon,
    required this.name,
    required this.members,
    required this.recentMessage,
    required this.kickedMembers,
  });

  Community copyWith({
    String? id,
    String? admin,
    String? groupIcon,
    String? name,
    List<String>? members,
    String? recentMessage,
    Map<String, String>? kickedMembers,
  }) {
    return Community(
      id: id ?? this.id,
      admin: admin ?? this.admin,
      groupIcon: groupIcon ?? this.groupIcon,
      name: name ?? this.name,
      members: members ?? this.members,
      recentMessage: recentMessage ?? this.recentMessage,
      kickedMembers: kickedMembers ?? this.kickedMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'admin': admin,
      'groupIcon': groupIcon,
      'name': name,
      'members': members,
      'recentMessage': recentMessage,
      'kickedMembers': kickedMembers,
    };
  }

  factory Community.fromMap(Map<String, dynamic>? map) {
    return Community(
      id: map?['id'] as String? ?? '',
      admin: map?['admin'] as String? ?? '',
      groupIcon: map?['groupIcon'] as String? ?? '', // Corrected variable name
      name: map?['name'] as String? ?? '',
      members: List<String>.from(map?['members'] as List<dynamic>? ?? []),
      recentMessage: map?['recentMessage'] as String? ?? '',
      kickedMembers: Map<String, String>.from(
          map?['kickedMembers'] as Map<String, dynamic>? ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Community(id: $id, admin: $admin, groupIcon: $groupIcon, name: $name, members: $members, recentMessage: $recentMessage, kickedMembers: $kickedMembers)';
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.admin == admin &&
        other.groupIcon == groupIcon &&
        other.name == name &&
        listEquals(other.members, members) &&
        other.recentMessage == recentMessage &&
        mapEquals(other.kickedMembers, kickedMembers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        admin.hashCode ^
        groupIcon.hashCode ^
        name.hashCode ^
        members.hashCode ^
        recentMessage.hashCode ^
        kickedMembers.hashCode;
  }
}

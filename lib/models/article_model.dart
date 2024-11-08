// model
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Articles {
  final String author;
  final String? bannerImage;
  final String? username;
  final String? body;
  final String? brief;
  final String? link;
  final String? category;
  final String? postLength;
  final int? commentCount;
  final Timestamp postedOn;
  final String title;
  final String id;
  List<String> upVotes;
  List<String> downVotes;
  Articles({
    required this.author,
    this.bannerImage,
    this.username,
    this.body,
    this.brief,
    this.link,
    this.category,
    this.postLength,
    this.commentCount,
    required this.postedOn,
    required this.title,
    required this.id,
    required this.upVotes,
    required this.downVotes,
  });

  Articles copyWith({
    String? author,
    String? bannerImage,
    String? username,
    String? body,
    String? brief,
    String? link,
    String? category,
    String? communityName,
    String? communityProfilePic,
    String? postLength,
    int? commentCount,
    Timestamp? postedOn,
    String? title,
    String? id,
    List<String>? upVotes,
    List<String>? downVotes,
  }) {
    return Articles(
      author: author ?? this.author,
      bannerImage: bannerImage ?? this.bannerImage,
      username: username ?? this.username,
      body: body ?? this.body,
      brief: brief ?? this.brief,
      link: link ?? this.link,
      category: category ?? this.category,
      postLength: postLength ?? this.postLength,
      commentCount: commentCount ?? this.commentCount,
      postedOn: postedOn ?? this.postedOn,
      title: title ?? this.title,
      id: id ?? this.id,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'bannerImage': bannerImage,
      'username': username,
      'body': body,
      'brief': brief,
      'link': link,
      'category': category,
      'postLength': postLength,
      'commentCount': commentCount,
      'postedOn': postedOn,
      'title': title,
      'id': id,
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      author: map['author'],
      bannerImage: map['bannerImage'] ?? '',
      username: map['username'] ?? '',
      body: map['body'] ?? '',
      brief: map['brief'] ?? '',
      link: map['link'] ?? '',
      category: map['category'] ?? '',
      postLength: map['postLength'] ?? '',
      commentCount: map['commentCount'] ?? 0,
      postedOn: map['postedOn'],
      title: map['title'] ?? '',
      id: map['id'] as String,
      upVotes: List<String>.from(map['upVotes'] ?? []),
      downVotes: List<String>.from(map['downVotes'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Articles.fromJson(String source) =>
      Articles.fromMap(json.decode(source) as Map<String, dynamic>);
}

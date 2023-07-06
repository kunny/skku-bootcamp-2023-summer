import 'package:flutter/material.dart';

class Note {
  static const colorDefault = Colors.white;

  static const colorRed = Color(0xFFFFCDD2);

  static const colorOrange = Color(0xFFFFE0B2);

  static const colorYellow = Color(0xFFFFF9C4);

  static const colorLime = Color(0xFFF0F4C3);

  static const colorBlue = Color(0xFFBBDEFB);

  final String title;

  final String body;

  final Color color;

  final String? id;

  Note(
    this.body, {
    this.id,
    this.title = '',
    this.color = colorDefault,
  });

  Note.fromData(dynamic data)
      : this(
          data['body'],
          title: data['title'],
          color: Color(data['color']),
        );

  Map<String, dynamic> toData() {
    return {
      'title': title,
      'body': body,
      'color': color.value,
    };
  }
}

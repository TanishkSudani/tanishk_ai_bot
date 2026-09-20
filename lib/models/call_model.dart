import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CallModel {
  final String id;
  final String name;
  final String number;
  final String language;
  final String type; // 'in', 'out', 'miss'
  final String summary;
  final String time;
  final int unread;
  final String emoji;
  final Color color;

  const CallModel({
    String? id,
    required this.name,
    required this.number,
    required this.language,
    required this.type,
    required this.summary,
    required this.time,
    required this.unread,
    required this.emoji,
    required this.color,
  }) : id = id ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'language': language,
    'type': type,
    'summary': summary,
    'time': time,
    'unread': unread,
    'emoji': emoji,
    'color': color.toARGB32(),
  };

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'Unknown',
    number: json['number'] as String? ?? '',
    language: json['language'] as String? ?? 'Gujarati',
    type: json['type'] as String? ?? 'in',
    summary: json['summary'] as String? ?? '',
    time: json['time'] as String? ?? 'Just now',
    unread: json['unread'] as int? ?? 0,
    emoji: json['emoji'] as String? ?? '📞',
    color: json['color'] != null ? Color(json['color'] as int) : AppColors.accent,
  );
}

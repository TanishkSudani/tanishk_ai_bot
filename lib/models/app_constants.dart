import 'package:flutter/material.dart';

class AppColors {
  static const bg       = Color(0xFF0A0F1A);
  static const surface  = Color(0xFF111827);
  static const card     = Color(0xFF1A2235);
  static const border   = Color(0xFF1E2D45);
  static const accent   = Color(0xFF3B82F6);
  static const green    = Color(0xFF22C55E);
  static const wa       = Color(0xFF25D366);
  static const red      = Color(0xFFEF4444);
  static const orange   = Color(0xFFF59E0B);
  static const purple   = Color(0xFFA855F7);
  static const text     = Color(0xFFF1F5F9);
  static const sub      = Color(0xFF94A3B8);
  static const muted    = Color(0xFF475569);
}

class CallModel {
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
    required this.name,
    required this.number,
    required this.language,
    required this.type,
    required this.summary,
    required this.time,
    required this.unread,
    required this.emoji,
    required this.color,
  });
}

const List<CallModel> todayCalls = [
  CallModel(
    name: 'Rahul Shah',
    number: '+91 98765 43210',
    language: 'Gujarati',
    type: 'in',
    summary: 'Delivery query · Bot resolved ✅',
    time: '2m ago',
    unread: 0,
    emoji: '😊',
    color: AppColors.accent,
  ),
  CallModel(
    name: 'Priya Patel',
    number: '+91 77001 22334',
    language: 'Hindi',
    type: 'miss',
    summary: 'Missed call · Summary sent ⚠️',
    time: '8m ago',
    unread: 1,
    emoji: '👩',
    color: AppColors.purple,
  ),
  CallModel(
    name: 'Amit Verma',
    number: '+91 90012 33445',
    language: 'Gujarati',
    type: 'in',
    summary: 'New order enquiry · Action needed',
    time: '18m ago',
    unread: 1,
    emoji: '👨',
    color: AppColors.orange,
  ),
  CallModel(
    name: "Maria D'Souza",
    number: '+91 88997 66554',
    language: 'English',
    type: 'in',
    summary: 'Business hours query · Resolved ✅',
    time: '1h ago',
    unread: 0,
    emoji: '👩',
    color: AppColors.green,
  ),
  CallModel(
    name: 'Ravi Kumar',
    number: '+91 70011 88223',
    language: 'Tamil',
    type: 'out',
    summary: 'Outgoing callback · Scheduled',
    time: '2h ago',
    unread: 0,
    emoji: '🧑',
    color: AppColors.accent,
  ),
];

const List<CallModel> yesterdayCalls = [
  CallModel(
    name: 'Anjali Mehta',
    number: '+91 95555 12312',
    language: 'Gujarati',
    type: 'in',
    summary: 'Refund request · Escalated to you',
    time: 'Yesterday',
    unread: 0,
    emoji: '👩',
    color: AppColors.purple,
  ),
  CallModel(
    name: 'Unknown Caller',
    number: '+91 80033 99001',
    language: 'Hindi',
    type: 'miss',
    summary: 'Dropped call · 22 seconds',
    time: 'Yesterday',
    unread: 0,
    emoji: '❓',
    color: AppColors.red,
  ),
];

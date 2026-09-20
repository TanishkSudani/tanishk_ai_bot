enum CallStatus {
  idle,
  incoming,
  connected,
  paused,
  ended,
}

enum AudioState {
  idle,
  listening,
  thinking,
  speaking,
}

class CallerProfile {
  final String name;
  final String phone;
  final String location;
  final String preferredLanguage;
  final String emoji;

  const CallerProfile({
    required this.name,
    required this.phone,
    required this.location,
    required this.preferredLanguage,
    required this.emoji,
  });

  static const CallerProfile defaultCaller = CallerProfile(
    name: 'Rahul Shah',
    phone: '+91 98765 43210',
    location: 'Surat, Gujarat',
    preferredLanguage: 'Gujarati',
    emoji: '👨',
  );

  static const List<CallerProfile> sampleCallers = [
    CallerProfile(
      name: 'Rahul Shah',
      phone: '+91 98765 43210',
      location: 'Surat, Gujarat',
      preferredLanguage: 'Gujarati',
      emoji: '👨',
    ),
    CallerProfile(
      name: 'Priya Patel',
      phone: '+91 77001 22334',
      location: 'Ahmedabad, Gujarat',
      preferredLanguage: 'Gujarati',
      emoji: '👩',
    ),
    CallerProfile(
      name: 'Amit Verma',
      phone: '+91 90012 33445',
      location: 'Mumbai, Maharashtra',
      preferredLanguage: 'Hindi',
      emoji: '🧑',
    ),
    CallerProfile(
      name: 'Maria D\'Souza',
      phone: '+91 88997 66554',
      location: 'Bengaluru, Karnataka',
      preferredLanguage: 'English',
      emoji: '👩‍💼',
    ),
  ];
}

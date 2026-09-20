class TranscriptEntry {
  final String id;
  final String speaker;
  final String text;
  final String timestamp;
  final String? language;
  final bool isAi;

  const TranscriptEntry({
    required this.id,
    required this.speaker,
    required this.text,
    required this.timestamp,
    this.language,
    required this.isAi,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'speaker': speaker,
    'text': text,
    'timestamp': timestamp,
    'language': language,
    'isAi': isAi,
  };

  factory TranscriptEntry.fromJson(Map<String, dynamic> json) => TranscriptEntry(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    speaker: json['speaker'] as String? ?? 'Caller',
    text: json['text'] as String? ?? '',
    timestamp: json['timestamp'] as String? ?? '',
    language: json['language'] as String?,
    isAi: json['isAi'] as bool? ?? false,
  );
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isInitialized;

  void Function(String words, bool isFinal)? onResult;
  VoidCallback? onListeningStarted;
  VoidCallback? onListeningStopped;

  Future<bool> init() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          debugPrint('Speech recognition error: ${error.errorMsg}');
          _isListening = false;
          onListeningStopped?.call();
        },
        onStatus: (status) {
          debugPrint('Speech recognition status: $status');
          if (status == 'notListening' || status == 'done') {
            _isListening = false;
            onListeningStopped?.call();
          }
        },
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('Speech recognition init exception: $e');
      _isInitialized = false;
      return false;
    }
  }

  String _resolveLocale(String? language) {
    if (language == null) return 'en_IN';
    final lower = language.toLowerCase();
    if (lower.contains('gujarati') || lower.contains('guj')) {
      return 'gu_IN';
    } else if (lower.contains('hindi') || lower.contains('hin')) {
      return 'hi_IN';
    } else if (lower.contains('tamil') || lower.contains('tam')) {
      return 'ta_IN';
    }
    return 'en_IN';
  }

  Future<bool> startListening({String? language}) async {
    if (!_isInitialized) {
      final ok = await init();
      if (!ok) return false;
    }

    try {
      final localeId = _resolveLocale(language);
      _isListening = true;
      onListeningStarted?.call();

      await _speech.listen(
        onResult: (result) {
          onResult?.call(result.recognizedWords, result.finalResult);
        },
        localeId: localeId,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Error starting speech listening: $e');
      _isListening = false;
      onListeningStopped?.call();
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      _isListening = false;
      await _speech.stop();
      onListeningStopped?.call();
    } catch (e) {
      debugPrint('Error stopping speech listening: $e');
    }
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  VoidCallback? onSpeechStart;
  VoidCallback? onSpeechComplete;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.85);

      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        onSpeechStart?.call();
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        onSpeechComplete?.call();
      });

      _flutterTts.setErrorHandler((dynamic msg) {
        _isPlaying = false;
        debugPrint('TTS Error: $msg');
        onSpeechComplete?.call();
      });

      _flutterTts.setCancelHandler(() {
        _isPlaying = false;
        onSpeechComplete?.call();
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  String _resolveLanguageCode(String? language) {
    if (language == null) return 'en-IN';
    final lower = language.toLowerCase();
    if (lower.contains('gujarati') || lower.contains('guj')) {
      return 'gu-IN';
    } else if (lower.contains('hindi') || lower.contains('hin')) {
      return 'hi-IN';
    } else if (lower.contains('tamil') || lower.contains('tam')) {
      return 'ta-IN';
    }
    return 'en-IN';
  }

  Future<void> speak(String text, {String? language}) async {
    if (!_isInitialized) await init();
    try {
      await stop();
      final langCode = _resolveLanguageCode(language);
      
      // Try setting language, fallback to hi-IN or en-IN if gu-IN is not available
      try {
        final isAvailable = await _flutterTts.isLanguageAvailable(langCode);
        if (isAvailable == true) {
          await _flutterTts.setLanguage(langCode);
        } else {
          // Gujarati fallback to Hindi or English on engines lacking gu-IN
          if (langCode == 'gu-IN') {
            final hiAvail = await _flutterTts.isLanguageAvailable('hi-IN');
            await _flutterTts.setLanguage(hiAvail == true ? 'hi-IN' : 'en-IN');
          } else {
            await _flutterTts.setLanguage('en-IN');
          }
        }
      } catch (_) {
        await _flutterTts.setLanguage('en-IN');
      }

      _isPlaying = true;
      onSpeechStart?.call();
      await _flutterTts.speak(text);
    } catch (e) {
      _isPlaying = false;
      debugPrint('Failed to speak TTS: $e');
      onSpeechComplete?.call();
    }
  }

  Future<void> stop() async {
    try {
      _isPlaying = false;
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Failed to stop TTS: $e');
    }
  }
}

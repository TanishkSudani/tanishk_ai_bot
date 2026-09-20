import 'dart:async';
import 'package:flutter/material.dart';
import '../models/call_session_state.dart';
import '../models/transcript_model.dart';
import '../models/call_model.dart';
import 'ai_service.dart';
import 'tts_service.dart';
import 'speech_service.dart';
import 'storage_service.dart';
import 'whatsapp_service.dart';

class CallSessionService extends ChangeNotifier {
  static final CallSessionService _instance = CallSessionService._internal();
  factory CallSessionService() => _instance;
  CallSessionService._internal();

  final AiService _ai = AiService();
  final TtsService _tts = TtsService();
  final SpeechService _speech = SpeechService();
  final StorageService _storage = StorageService();
  final WhatsAppService _wa = WhatsAppService();

  CallStatus _status = CallStatus.idle;
  AudioState _audioState = AudioState.idle;
  CallerProfile _caller = CallerProfile.defaultCaller;

  int _durationSeconds = 0;
  Timer? _callTimer;

  bool _isMuted = false;
  bool _isOnHold = false;
  bool _isSpeakerOn = true;
  String _detectedLanguage = 'Gujarati';
  String _currentPartialSpeech = '';

  final List<TranscriptEntry> _transcript = [];

  // Getters
  CallStatus get status => _status;
  AudioState get audioState => _audioState;
  CallerProfile get caller => _caller;
  int get durationSeconds => _durationSeconds;
  bool get isMuted => _isMuted;
  bool get isOnHold => _isOnHold;
  bool get isSpeakerOn => _isSpeakerOn;
  String get detectedLanguage => _detectedLanguage;
  String get currentPartialSpeech => _currentPartialSpeech;
  List<TranscriptEntry> get transcript => List.unmodifiable(_transcript);

  String get durationString {
    final m = (_durationSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_durationSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void init() {
    _tts.init();
    _speech.init();

    _tts.onSpeechStart = () {
      _audioState = AudioState.speaking;
      notifyListeners();
    };

    _tts.onSpeechComplete = () {
      if (_status == CallStatus.connected && !_isOnHold && !_isMuted) {
        _audioState = AudioState.listening;
        _listenForCaller();
      } else {
        _audioState = AudioState.idle;
      }
      notifyListeners();
    };

    _speech.onResult = (words, isFinal) {
      _currentPartialSpeech = words;
      notifyListeners();
      if (isFinal && words.trim().isNotEmpty) {
        _currentPartialSpeech = '';
        sendCallerMessage(words.trim());
      }
    };
  }

  /// Start a live call session
  Future<void> startCall({CallerProfile? profile}) async {
    init();
    _caller = profile ?? CallerProfile.defaultCaller;
    _detectedLanguage = _caller.preferredLanguage;
    _durationSeconds = 0;
    _isMuted = false;
    _isOnHold = false;
    _transcript.clear();
    _currentPartialSpeech = '';
    _status = CallStatus.connected;
    _audioState = AudioState.speaking;
    notifyListeners();

    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _durationSeconds++;
      notifyListeners();
    });

    // Initial greeting from AI bot
    final botName = _storage.settings.botName;
    final businessName = _storage.settings.businessName;
    String greeting;

    if (_detectedLanguage == 'Gujarati') {
      greeting = 'નમસ્તે ${_caller.name} જી! હું $businessName થી $botName બોલું છું. હું તમને કેવી રીતે મદદ કરી શકું?';
    } else if (_detectedLanguage == 'Hindi') {
      greeting = 'नमस्ते ${_caller.name} जी! मैं $businessName से $botName बात कर रही हूँ। बताइए मैं क्या सहायता करूँ?';
    } else {
      greeting = 'Hello ${_caller.name}! This is $botName from $businessName. How can I help you today?';
    }

    _addTranscriptEntry(speaker: 'AI Bot', text: greeting, isAi: true);
    await _tts.speak(greeting, language: _detectedLanguage);
  }

  /// Send spoken/typed text from caller into the AI pipeline
  Future<void> sendCallerMessage(String text) async {
    if (_status != CallStatus.connected || _isOnHold) return;

    // Detect language if autoLang setting is on
    if (_storage.settings.autoLang) {
      _detectedLanguage = _ai.detectLanguage(text);
    }

    _addTranscriptEntry(speaker: 'Caller', text: text, isAi: false);
    _audioState = AudioState.thinking;
    notifyListeners();

    // Generate AI response
    final response = await _ai.getResponse(
      userQuery: text,
      callerName: _caller.name,
      botName: _storage.settings.botName,
      businessName: _storage.settings.businessName,
      preferredLanguage: _detectedLanguage,
      geminiApiKey: _storage.settings.geminiApiKey,
      history: _transcript,
    );

    _addTranscriptEntry(speaker: 'AI Bot', text: response, isAi: true);
    _audioState = AudioState.speaking;
    notifyListeners();

    await _tts.speak(response, language: _detectedLanguage);
  }

  Future<void> _listenForCaller() async {
    if (_isMuted || _isOnHold || _status != CallStatus.connected) return;
    await _speech.startListening(language: _detectedLanguage);
  }

  void _addTranscriptEntry({
    required String speaker,
    required String text,
    required bool isAi,
  }) {
    _transcript.add(
      TranscriptEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        speaker: speaker,
        text: text,
        timestamp: durationString,
        language: _detectedLanguage,
        isAi: isAi,
      ),
    );
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _speech.stopListening();
      _audioState = AudioState.idle;
    } else {
      _audioState = AudioState.listening;
      _listenForCaller();
    }
    notifyListeners();
  }

  void toggleHold() {
    _isOnHold = !_isOnHold;
    if (_isOnHold) {
      _tts.stop();
      _speech.stopListening();
      _audioState = AudioState.idle;
    } else {
      _audioState = AudioState.listening;
      _listenForCaller();
    }
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _detectedLanguage = lang;
    notifyListeners();
  }

  void reset() {
    _callTimer?.cancel();
    _callTimer = null;
    _tts.stop();
    _speech.stopListening();
    _status = CallStatus.idle;
    _audioState = AudioState.idle;
    _durationSeconds = 0;
    _transcript.clear();
    _currentPartialSpeech = '';
    notifyListeners();
  }

  /// End call and return structured summary
  Future<String> endCall() async {
    _callTimer?.cancel();
    _callTimer = null;
    await _tts.stop();
    await _speech.stopListening();

    _status = CallStatus.ended;
    _audioState = AudioState.idle;
    notifyListeners();

    final summary = _ai.generateWhatsAppSummary(
      callerName: _caller.name,
      callerPhone: _caller.phone,
      duration: durationString,
      language: _detectedLanguage,
      transcript: _transcript,
    );

    // Save call to permanent history
    final newCall = CallModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _caller.name,
      number: _caller.phone,
      language: _detectedLanguage,
      type: 'in',
      summary: 'Call ($durationString) · Bot handled ✅',
      time: 'Just now',
      unread: 0,
      emoji: _caller.emoji,
      color: const Color(0xFF22C55E),
    );
    await _storage.addCall(newCall);

    return summary;
  }

  /// Dispatch summary directly to WhatsApp
  Future<bool> dispatchToWhatsApp(String summary) async {
    final targetPhone = _storage.settings.waNumber;
    return await _wa.sendSummary(phoneNumber: targetPhone, message: summary);
  }
}

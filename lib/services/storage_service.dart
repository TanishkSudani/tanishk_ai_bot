import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const _keySettings = 'tanishk_ai_settings_v1';
  static const _keyCalls = 'tanishk_ai_calls_v1';

  AiSettingsModel _settings = AiSettingsModel();
  List<CallModel> _calls = [];

  AiSettingsModel get settings => _settings;
  List<CallModel> get calls => _calls;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load settings
    final settingsJson = prefs.getString(_keySettings);
    if (settingsJson != null) {
      try {
        _settings = AiSettingsModel.fromJson(jsonDecode(settingsJson));
      } catch (_) {
        _settings = AiSettingsModel();
      }
    } else {
      // Migrate legacy keys if present
      _settings = AiSettingsModel(
        botName: prefs.getString('bot_name') ?? 'Priya',
        businessName: prefs.getString('business_name') ?? "Tanishk's AI Solutions",
        waNumber: prefs.getString('wa_number') ?? '+91 98765 43210',
        geminiApiKey: prefs.getString('gemini_api_key') ?? '',
        claudeApiKey: prefs.getString('claude_key') ?? 'sk-ant-sample-claude-key-8374',
        twilioSid: prefs.getString('twilio_sid') ?? 'AC_sample_twilio_sid_92834',
        twilioToken: prefs.getString('twilio_token') ?? '••••••••••••••••••••••••',
        deepgramKey: prefs.getString('deepgram_key') ?? 'dg_sample_deepgram_key_1928',
        autoLang: prefs.getBool('auto_lang') ?? true,
        sendWa: prefs.getBool('send_wa') ?? true,
        record: prefs.getBool('record') ?? true,
        urgentFlag: prefs.getBool('urgent_flag') ?? true,
      );
    }

    // Load calls
    final callsJson = prefs.getString(_keyCalls);
    if (callsJson != null) {
      try {
        final List list = jsonDecode(callsJson);
        _calls = list.map((item) => CallModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {
        _calls = List.from(initialTodayCalls);
      }
    } else {
      _calls = List.from(initialTodayCalls);
    }
  }

  Future<void> saveSettings(AiSettingsModel newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, jsonEncode(newSettings.toJson()));

    // Also write legacy keys for cross-compatibility
    await prefs.setString('bot_name', newSettings.botName);
    await prefs.setString('business_name', newSettings.businessName);
    await prefs.setString('wa_number', newSettings.waNumber);
    await prefs.setString('gemini_api_key', newSettings.geminiApiKey);
    await prefs.setString('claude_key', newSettings.claudeApiKey);
    await prefs.setString('twilio_sid', newSettings.twilioSid);
    await prefs.setString('twilio_token', newSettings.twilioToken);
    await prefs.setString('deepgram_key', newSettings.deepgramKey);
    await prefs.setBool('auto_lang', newSettings.autoLang);
    await prefs.setBool('send_wa', newSettings.sendWa);
    await prefs.setBool('record', newSettings.record);
    await prefs.setBool('urgent_flag', newSettings.urgentFlag);
  }

  Future<void> addCall(CallModel call) async {
    _calls.insert(0, call);
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _calls.map((c) => c.toJson()).toList();
      await prefs.setString(_keyCalls, jsonEncode(jsonList));
    } catch (_) {
      // In-memory list is always preserved
    }
  }
}

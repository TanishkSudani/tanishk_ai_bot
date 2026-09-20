class AiSettingsModel {
  String botName;
  String businessName;
  String waNumber;
  String geminiApiKey;
  String claudeApiKey;
  String twilioSid;
  String twilioToken;
  String deepgramKey;
  bool autoLang;
  bool sendWa;
  bool record;
  bool urgentFlag;
  double speechRate;
  double speechPitch;

  AiSettingsModel({
    this.botName = 'Priya',
    this.businessName = "Tanishk's AI Solutions",
    this.waNumber = '+91 98765 43210',
    this.geminiApiKey = '',
    this.claudeApiKey = 'sk-ant-sample-claude-key-8374',
    this.twilioSid = 'AC_sample_twilio_sid_92834',
    this.twilioToken = '••••••••••••••••••••••••',
    this.deepgramKey = 'dg_sample_deepgram_key_1928',
    this.autoLang = true,
    this.sendWa = true,
    this.record = true,
    this.urgentFlag = true,
    this.speechRate = 0.9,
    this.speechPitch = 1.0,
  });

  Map<String, dynamic> toJson() => {
    'bot_name': botName,
    'business_name': businessName,
    'wa_number': waNumber,
    'gemini_api_key': geminiApiKey,
    'claude_key': claudeApiKey,
    'twilio_sid': twilioSid,
    'twilio_token': twilioToken,
    'deepgram_key': deepgramKey,
    'auto_lang': autoLang,
    'send_wa': sendWa,
    'record': record,
    'urgent_flag': urgentFlag,
    'speech_rate': speechRate,
    'speech_pitch': speechPitch,
  };

  factory AiSettingsModel.fromJson(Map<String, dynamic> json) => AiSettingsModel(
    botName: json['bot_name'] as String? ?? 'Priya',
    businessName: json['business_name'] as String? ?? "Tanishk's AI Solutions",
    waNumber: json['wa_number'] as String? ?? '+91 98765 43210',
    geminiApiKey: json['gemini_api_key'] as String? ?? '',
    claudeApiKey: json['claude_key'] as String? ?? 'sk-ant-sample-claude-key-8374',
    twilioSid: json['twilio_sid'] as String? ?? 'AC_sample_twilio_sid_92834',
    twilioToken: json['twilio_token'] as String? ?? '••••••••••••••••••••••••',
    deepgramKey: json['deepgram_key'] as String? ?? 'dg_sample_deepgram_key_1928',
    autoLang: json['auto_lang'] as bool? ?? true,
    sendWa: json['send_wa'] as bool? ?? true,
    record: json['record'] as bool? ?? true,
    urgentFlag: json['urgent_flag'] as bool? ?? true,
    speechRate: (json['speech_rate'] as num?)?.toDouble() ?? 0.9,
    speechPitch: (json['speech_pitch'] as num?)?.toDouble() ?? 1.0,
  );
}

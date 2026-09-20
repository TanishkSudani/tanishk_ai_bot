import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/transcript_model.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  /// Detect language from user text
  String detectLanguage(String text) {
    final lower = text.toLowerCase().trim();

    // Check Gujarati Unicode range \u0A80-\u0AFF
    final hasGujaratiScript = RegExp(r'[\u0A80-\u0AFF]').hasMatch(text);
    if (hasGujaratiScript) return 'Gujarati';

    // Check Hindi Unicode range \u0900-\u097F
    final hasHindiScript = RegExp(r'[\u0900-\u097F]').hasMatch(text);
    if (hasHindiScript) return 'Hindi';

    // Tokenize text into words
    final words = lower.split(RegExp(r'[^a-zA-Z0-9]+')).where((w) => w.isNotEmpty).toSet();
    int gujaratiMatches = 0;
    int hindiMatches = 0;

    const gujaratiSet = {
      'kem', 'cho', 'tamare', 'tamaro', 'maro', 'nathi', 'aavyo', 'aavse',
      'shu', 'su', 'saru', 'bhai', 'ha', 'haa', 'kaho', 'bol', 'paisa', 'bhaav',
      'aavshe', 'kyare', 'jovu', 'malse', 'swagat', 'krupa', 'chhe', '6e', 'thase'
    };

    const hindiSet = {
      'namaste', 'kaise', 'ho', 'mera', 'meri', 'mere', 'aayega', 'kya', 'kab', 'batao',
      'chahiye', 'bhaiya', 'kitna', 'hoga', 'kahan', 'pahuncha', 'baat', 'karni', 'hai'
    };

    for (final w in words) {
      if (gujaratiSet.contains(w)) gujaratiMatches++;
      if (hindiSet.contains(w)) hindiMatches++;
    }

    if (gujaratiMatches > 0 && gujaratiMatches >= hindiMatches) return 'Gujarati';
    if (hindiMatches > 0) return 'Hindi';

    return 'English';
  }

  /// Generate AI conversational response
  Future<String> getResponse({
    required String userQuery,
    required String callerName,
    required String botName,
    required String businessName,
    String? preferredLanguage,
    String? geminiApiKey,
    List<TranscriptEntry> history = const [],
  }) async {
    final language = preferredLanguage ?? detectLanguage(userQuery);

    // If Gemini API Key is provided, attempt live cloud call
    if (geminiApiKey != null && geminiApiKey.trim().isNotEmpty) {
      try {
        final cloudResponse = await _callGeminiApi(
          query: userQuery,
          apiKey: geminiApiKey.trim(),
          callerName: callerName,
          botName: botName,
          businessName: businessName,
          language: language,
          history: history,
        );
        if (cloudResponse != null && cloudResponse.trim().isNotEmpty) {
          return cloudResponse.trim();
        }
      } catch (e) {
        debugPrint('Gemini Cloud API failed, falling back to local engine: $e');
      }
    }

    // Built-in intelligent conversational response engine
    return _generateLocalResponse(
      query: userQuery,
      language: language,
      callerName: callerName,
      botName: botName,
      businessName: businessName,
    );
  }

  Future<String?> _callGeminiApi({
    required String query,
    required String apiKey,
    required String callerName,
    required String botName,
    required String businessName,
    required String language,
    required List<TranscriptEntry> history,
  }) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    final systemInstruction = '''
You are $botName, a friendly, professional AI voice calling assistant for "$businessName".
You are speaking directly to a customer named $callerName over a live telephone call.
Current conversation language is: $language.
Always reply in $language.
Keep replies very short, polite, conversational, and direct (maximum 1 to 2 sentences) suitable for telephone speech.
Never use markdown asterisks or bullet points. Just natural spoken words.
''';

    final contents = <Map<String, dynamic>>[
      {
        'role': 'user',
        'parts': [
          {'text': '$systemInstruction\nCustomer says: $query'}
        ]
      }
    ];

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'] as String?;
        }
      }
    }
    return null;
  }

  String _generateLocalResponse({
    required String query,
    required String language,
    required String callerName,
    required String botName,
    required String businessName,
  }) {
    final q = query.toLowerCase();

    // Gujarati language responses
    if (language == 'Gujarati') {
      if (q.contains('kem cho') || q.contains('hello') || q.contains('namaste') || q.contains('namaskar')) {
        return 'નમસ્તે $callerName જી! હું $botName છું. હું તમને કેવી રીતે મદદ કરી શકું?';
      } else if (q.contains('order') || q.contains('delivery') || q.contains('parcel') || q.contains('dispatch') || q.contains('srt')) {
        return 'તમારો ઓર્ડર નંબર SRT-2847 પેક થઈ ગયો છે અને આજે સાંજે ૬ વાગ્યા સુધીમાં પહોંચી જશે.';
      } else if (q.contains('price') || q.contains('bhav') || q.contains('rate') || q.contains('cost') || q.contains('kharch')) {
        return 'અમારા સ્માર્ટ બિઝનેસ AI બોટ પ્લાન દર મહિને ફક્ત ₹૯૯૯ થી શરૂ થાય છે. વિગતો હું તમને WhatsApp પર મોકલી આપું?';
      } else if (q.contains('owner') || q.contains('tanishk') || q.contains('malik') || q.contains('talk') || q.contains('vaat')) {
        return 'ચોક્કસ, હું તનિષ્કભાઈ સાથે તમારી આ વાતચીતની સમરી વોટ્સએપ પર મોકલી આપું છું. તેઓ ટૂંક સમયમાં સંપર્ક કરશે.';
      } else if (q.contains('refund') || q.contains('cancel') || q.contains('return') || q.contains('paisa')) {
        return 'તમારા રિફંડની પ્રોસેસ શરૂ કરી દીધી છે. ૨૪ કલાકમાં તમારા બેંક એકાઉન્ટમાં પૈસા આવી જશે.';
      } else if (q.contains('time') || q.contains('timing') || q.contains('khullo') || q.contains('bandh')) {
        return 'અમારો સ્ટોર સવારે ૧૦ થી રાત્રે ૮ વાગ્યા સુધી ખુલ્લો રહે છે. તમે ગમે ત્યારે મુલાકાત લઈ શકો છો.';
      } else if (q.contains('aabhar') || q.contains('thank') || q.contains('shukriya') || q.contains('theek')) {
        return 'ખૂબ ખૂબ આભાર $callerName ભાઈ! તમારો દિવસ શુભ રહે!';
      }
      return 'સમજાયું $callerName જી, હું તમારી વાત નોંધી લઉં છું અને વિગતો તરત જ ચેક કરું છું.';
    }

    // Hindi language responses
    if (language == 'Hindi') {
      if (q.contains('namaste') || q.contains('hello') || q.contains('kaise')) {
        return 'नमस्ते $callerName जी! मैं $businessName से $botName बोल रही हूँ। बताइए मैं आपकी क्या सहायता करूँ?';
      } else if (q.contains('order') || q.contains('delivery') || q.contains('parcel')) {
        return 'आपका आर्डर SRT-2847 निकल चुका है और आज शाम ६ बजे तक डिलीवर हो जाएगा।';
      } else if (q.contains('owner') || q.contains('baat') || q.contains('tanishk')) {
        return 'जी बिल्कुल, मैं तनिष्क जी को आपकी कॉल की समरी तुरंत व्हाट्सएप कर रही हूँ। वे जल्द कॉल करेंगे।';
      } else if (q.contains('price') || q.contains('kitna') || q.contains('cost')) {
        return 'हमारा AI बॉट प्लान ₹९९९ प्रति माह से शुरू होता है। क्या मैं इसका ब्रोशर व्हाट्सएप पर भेज दूँ?';
      } else if (q.contains('thank') || q.contains('dhanyavad') || q.contains('shukriya')) {
        return 'बहुत-बहुत धन्यवाद $callerName जी! आपका दिन शुभ हो!';
      }
      return 'जी $callerName जी, मैंने आपकी बात नोट कर ली है। क्या मैं आपकी कोई और सहायता कर सकती हूँ?';
    }

    // English language responses
    if (q.contains('hello') || q.contains('hi') || q.contains('hey')) {
      return 'Hello $callerName! This is $botName from $businessName. How can I help you today?';
    } else if (q.contains('order') || q.contains('delivery') || q.contains('tracking')) {
      return 'Your order SRT-2847 has been dispatched and will arrive by 6:00 PM today.';
    } else if (q.contains('owner') || q.contains('manager') || q.contains('speak') || q.contains('call')) {
      return 'Certainly, I am forwarding your message and call summary to Mr. Tanishk right now.';
    } else if (q.contains('price') || q.contains('cost') || q.contains('plan')) {
      return 'Our Smart Business AI Bot service starts at ₹999 per month. Shall I send details to your WhatsApp?';
    } else if (q.contains('thank') || q.contains('bye') || q.contains('great')) {
      return 'Thank you for calling $businessName, $callerName! Have a wonderful day!';
    }
    return 'Got it $callerName. I have recorded your request and our team will follow up promptly.';
  }

  /// Format structured WhatsApp summary from live transcripts
  String generateWhatsAppSummary({
    required String callerName,
    required String callerPhone,
    required String duration,
    required String language,
    required List<TranscriptEntry> transcript,
    String? topic,
    String? resolution,
  }) {
    final cleanTopic = topic ?? 'Customer phone enquiry regarding service & orders';
    final cleanResolution = resolution ?? 'AI bot resolved caller request successfully';

    final buffer = StringBuffer();
    buffer.writeln('📞 *Tanishk AI Bot — Live Call Summary*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('👤 *Caller:* $callerName');
    buffer.writeln('📱 *Phone:* $callerPhone');
    buffer.writeln('⏱ *Duration:* $duration');
    buffer.writeln('🌐 *Language:* $language');
    buffer.writeln('📋 *Topic:* $cleanTopic');
    buffer.writeln('✅ *Status:* $cleanResolution');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('💬 *Key Transcript:*');

    final lastMessages = transcript.take(6).toList();
    for (final entry in lastMessages) {
      final speakerIcon = entry.isAi ? '🤖' : '👤';
      buffer.writeln('$speakerIcon ${entry.speaker}: ${entry.text}');
    }

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🚀 _Automatically logged & dispatched by Tanishk AI Assistant_');
    return buffer.toString();
  }
}

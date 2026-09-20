import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanishks_ai_bot/config/app_constants.dart';
import 'package:tanishks_ai_bot/services/ai_service.dart';
import 'package:tanishks_ai_bot/services/call_session_service.dart';
import 'package:tanishks_ai_bot/services/whatsapp_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('Live Call Pipeline & AI Testing', () {
    final ai = AiService();
    final callService = CallSessionService();
    final wa = WhatsAppService();

    test('Language Auto-Detection Test (Gujarati, Hindi, English)', () {
      // Gujarati detection
      expect(ai.detectLanguage('Kem cho bhai, maro order kyare aavse?'), 'Gujarati');
      expect(ai.detectLanguage('મારો ઓર્ડર ક્યારે મળશે?'), 'Gujarati');
      expect(ai.detectLanguage('bhav shu chhe tamaro?'), 'Gujarati');

      // Hindi detection
      expect(ai.detectLanguage('Namaste bhaiya mera order kab aayega?'), 'Hindi');
      expect(ai.detectLanguage('नमस्ते क्या हाल है?'), 'Hindi');

      // English detection
      expect(ai.detectLanguage('Hello, where is my package?'), 'English');
    });

    test('AI Conversational Response in Gujarati', () async {
      final response1 = await ai.getResponse(
        userQuery: 'Kem cho bhai, tame kon cho?',
        callerName: 'Rahul Shah',
        botName: 'Priya',
        businessName: "Tanishk's AI Solutions",
      );
      expect(response1.contains('નમસ્તે') || response1.contains('Rahul'), isTrue);

      final response2 = await ai.getResponse(
        userQuery: 'Maro order number SRT-2847 kyare aavse?',
        callerName: 'Rahul Shah',
        botName: 'Priya',
        businessName: "Tanishk's AI Solutions",
      );
      expect(response2.contains('SRT-2847') || response2.contains('ઓર્ડર'), isTrue);

      final response3 = await ai.getResponse(
        userQuery: 'Tanishk bhai sathe vaat karavo urgent che',
        callerName: 'Rahul Shah',
        botName: 'Priya',
        businessName: "Tanishk's AI Solutions",
      );
      expect(response3.contains('તનિષ્ક') || response3.contains('વોટ્સએપ'), isTrue);
    });

    test('AI Conversational Response in Hindi & English', () async {
      final hindiRes = await ai.getResponse(
        userQuery: 'Mera order delivery kab hoga?',
        callerName: 'Amit Verma',
        botName: 'Priya',
        businessName: "Tanishk's AI Solutions",
      );
      expect(hindiRes.contains('आर्डर') || hindiRes.contains('SRT-2847') || hindiRes.contains('डिलीवर'), isTrue);

      final engRes = await ai.getResponse(
        userQuery: 'Where is my delivery order tracking?',
        callerName: 'Maria',
        botName: 'Priya',
        businessName: "Tanishk's AI Solutions",
      );
      expect(engRes.contains('order') || engRes.contains('dispatched'), isTrue);
    });

    test('Live Call Session Lifecycle (Start -> Speech -> Transcript -> End -> WhatsApp Summary)', () async {
      // 1. Start Call with Gujarati caller
      await callService.startCall(profile: CallerProfile.sampleCallers[0]);
      expect(callService.status, CallStatus.connected);
      expect(callService.caller.name, 'Rahul Shah');
      expect(callService.transcript.isNotEmpty, isTrue);
      expect(callService.transcript.first.isAi, isTrue);

      // 2. Caller speaks inquiry
      await callService.sendCallerMessage('Maro order SRT-2847 kyare aavse?');
      expect(callService.transcript.length, 3); // Greeting + Caller inquiry + AI reply
      expect(callService.transcript[1].speaker, 'Caller');
      expect(callService.transcript[2].speaker, 'AI Bot');

      // 3. Test Hold / Resume
      callService.toggleHold();
      expect(callService.isOnHold, isTrue);
      callService.toggleHold();
      expect(callService.isOnHold, isFalse);

      // 4. Test Mute / Unmute
      callService.toggleMute();
      expect(callService.isMuted, isTrue);
      callService.toggleMute();
      expect(callService.isMuted, isFalse);

      // 5. Caller says thank you
      await callService.sendCallerMessage('Theek che bhai, khub aabhar!');
      expect(callService.transcript.length, 5);

      // 6. End Call & Generate Summary
      final summary = await callService.endCall();
      expect(callService.status, CallStatus.ended);
      expect(summary.contains('Rahul Shah'), isTrue);
      expect(summary.contains('+91 98765 43210'), isTrue);
      expect(summary.contains('Gujarati'), isTrue);
      expect(summary.contains('Live Call Summary'), isTrue);

      // 7. Verify WhatsApp number cleaner
      final cleanedNumber = wa.cleanPhoneNumber('+91 98765 43210');
      expect(cleanedNumber, '919876543210');

      callService.reset();
    });
  });
}

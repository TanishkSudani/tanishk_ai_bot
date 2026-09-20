import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static final WhatsAppService _instance = WhatsAppService._internal();
  factory WhatsAppService() => _instance;
  WhatsAppService._internal();

  /// Clean phone number to digits only (e.g. "+91 98765-43210" -> "919876543210")
  String cleanPhoneNumber(String rawNumber) {
    return rawNumber.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Launch WhatsApp with prefilled message
  Future<bool> sendSummary({
    required String phoneNumber,
    required String message,
  }) async {
    final cleaned = cleanPhoneNumber(phoneNumber);
    final encodedMessage = Uri.encodeComponent(message);

    // 1. Try web/universal https://wa.me link
    final webUrl = Uri.parse('https://wa.me/$cleaned?text=$encodedMessage');
    
    // 2. Try native whatsapp:// URL
    final nativeUrl = Uri.parse('whatsapp://send?phone=$cleaned&text=$encodedMessage');

    try {
      if (await canLaunchUrl(nativeUrl)) {
        return await launchUrl(nativeUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(webUrl)) {
        return await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    return false;
  }

  /// Copy message to clipboard
  Future<void> copyToClipboard(String message) async {
    await Clipboard.setData(ClipboardData(text: message));
  }
}

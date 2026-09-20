import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_constants.dart';
import '../services/ai_service.dart';
import '../services/call_session_service.dart';
import '../services/storage_service.dart';
import '../services/whatsapp_service.dart';
import 'live_screen.dart';

class ChatScreen extends StatefulWidget {
  final CallModel call;
  const ChatScreen({super.key, required this.call});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final AiService _ai = AiService();
  final StorageService _storage = StorageService();
  final WhatsAppService _wa = WhatsAppService();

  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _storage.init();

    _messages.addAll([
      {
        'type': 'bot',
        'label': '🤖 AI Call Summary',
        'text':
            '📞 New Call Summary\n\n'
            '👤 Name: ${widget.call.name}\n'
            '📱 Contact: ${widget.call.number}\n'
            '🌐 Language: ${widget.call.language}\n'
            '⏱ Duration: 2m 14s\n\n'
            '📋 Topic: ${widget.call.summary}\n\n'
            '📝 Summary: Bot handled the call in ${widget.call.language}. Customer satisfied with resolution.\n\n'
            '✅ Action: No urgent follow-up required.',
        'time': _now(),
      },
    ]);
  }

  String _now() {
    final t = DateTime.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'type': 'me', 'text': text, 'time': _now()});
      _ctrl.clear();
    });
    _scrollDown();

    // Generate intelligent AI response
    final response = await _ai.getResponse(
      userQuery: text,
      callerName: widget.call.name,
      botName: _storage.settings.botName,
      businessName: _storage.settings.businessName,
      preferredLanguage: widget.call.language,
      geminiApiKey: _storage.settings.geminiApiKey,
    );

    if (mounted) {
      setState(() {
        _messages.add({
          'type': 'bot',
          'label': '🤖 BotHub',
          'text': response,
          'time': _now(),
        });
      });
      _scrollDown();
    }
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startLiveCall() {
    final profile = CallerProfile(
      name: widget.call.name,
      phone: widget.call.number,
      location: 'Gujarat, India',
      preferredLanguage: widget.call.language,
      emoji: widget.call.emoji,
    );
    CallSessionService().startCall(profile: profile);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LiveScreen(initialCaller: profile)),
    );
  }

  Future<void> _shareToWhatsApp() async {
    final summaryText = _messages.first['text'] as String? ?? 'Call summary with ${widget.call.name}';
    final targetPhone = _storage.settings.waNumber;
    await _wa.sendSummary(phoneNumber: targetPhone, message: summaryText);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.call.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(widget.call.emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.call.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.call.number,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                _AppBarAction(
                  icon: Icons.phone_in_talk_rounded,
                  tooltip: 'Start Live AI Voice Call',
                  onTap: _startLiveCall,
                ),
                const SizedBox(width: 6),
                _AppBarAction(
                  icon: Icons.share_rounded,
                  tooltip: 'Send to WhatsApp',
                  onTap: _shareToWhatsApp,
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // Language chip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: AppColors.surface,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${widget.call.language} speaker · AI handled · ${widget.call.time}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0F1A), Color(0xFF0D1220)],
                ),
              ),
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (ctx, i) {
                  final m = _messages[i];
                  final isMe = m['type'] == 'me';
                  return _Bubble(
                    isMe: isMe,
                    label: m['label'],
                    text: m['text'] ?? '',
                    time: m['time'] ?? '',
                  );
                },
              ),
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: 'Ask bot or send note...',
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                        filled: true,
                        fillColor: AppColors.card,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.accent),
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final bool isMe;
  final String? label;
  final String text;
  final String time;

  const _Bubble({
    required this.isMe,
    required this.text,
    required this.time,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1D4ED8) : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isMe ? Colors.white70 : AppColors.green,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
            ],
            SelectableText(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.text,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isMe ? Colors.white54 : AppColors.muted,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  const Icon(Icons.done_all_rounded, size: 13, color: Colors.white54),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _AppBarAction({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.text, size: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';
import '../models/call_session_state.dart';
import '../services/call_session_service.dart';
import '../widgets/live_waveform.dart';

class LiveScreen extends StatefulWidget {
  final CallerProfile? initialCaller;
  const LiveScreen({super.key, this.initialCaller});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final CallSessionService _callService = CallSessionService();
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _inputCtrl = TextEditingController();

  CallerProfile _selectedProfile = CallerProfile.defaultCaller;

  @override
  void initState() {
    super.initState();
    _selectedProfile = widget.initialCaller ?? CallerProfile.defaultCaller;
    _callService.addListener(_onServiceUpdate);

    // Only auto-start if an initial caller was explicitly passed (e.g. from Deploy or Chat screen)
    if (widget.initialCaller != null && (_callService.status == CallStatus.idle || _callService.status == CallStatus.ended)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _callService.startCall(profile: widget.initialCaller);
      });
    }
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _callService.removeListener(_onServiceUpdate);
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  void _handleSendText() {
    final text = _inputCtrl.text.trim();
    if (text.isNotEmpty) {
      _inputCtrl.clear();
      _callService.sendCallerMessage(text);
    }
  }

  Future<void> _handleEndCall() async {
    final summary = await _callService.endCall();
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CallSummaryDialog(
        summary: summary,
        caller: _callService.caller,
        duration: _callService.durationString,
        onWhatsApp: () async {
          await _callService.dispatchToWhatsApp(summary);
          if (ctx.mounted) Navigator.pop(ctx);
        },
        onRestart: () {
          Navigator.pop(ctx);
          _callService.startCall(profile: _selectedProfile);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final isConnected = _callService.status == CallStatus.connected;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.text),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isConnected ? AppColors.green : AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Live AI Voice Call',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isConnected ? AppColors.green : AppColors.red).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isConnected ? AppColors.green : AppColors.red).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  size: 10,
                  color: isConnected ? AppColors.green : AppColors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  isConnected ? 'LIVE CALL' : 'STANDBY',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isConnected ? AppColors.green : AppColors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: !isConnected
            ? _buildIdleLaunchView()
            : Column(
                children: [
            // Top Section: Caller Card & Waveform
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.activeCallGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accent, width: 2),
                          ),
                          child: Center(
                            child: Text(_callService.caller.emoji, style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _callService.caller.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_callService.caller.phone} · ${_callService.caller.location}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.sub,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Call timer pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 14, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                _callService.durationString,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Audio State Status Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAudioStateBadge(),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '🌐 ${_callService.detectedLanguage}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD8B4FE),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Live Waveform Visualizer
                    LiveWaveform(
                      audioState: _callService.audioState,
                      height: 38,
                      barCount: 24,
                    ),
                  ],
                ),
              ),
            ),

            // Middle Section: Live Speech & Call Controls Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildControlButton(
                      icon: _callService.isOnHold ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      label: _callService.isOnHold ? 'Resume' : 'Hold',
                      active: _callService.isOnHold,
                      activeColor: AppColors.orange,
                      onTap: _callService.toggleHold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildControlButton(
                      icon: _callService.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      label: _callService.isMuted ? 'Unmute' : 'Mute Bot',
                      active: _callService.isMuted,
                      activeColor: AppColors.red,
                      onTap: _callService.toggleMute,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildControlButton(
                      icon: Icons.call_end_rounded,
                      label: 'End Call',
                      active: true,
                      activeColor: AppColors.red,
                      onTap: _handleEndCall,
                    ),
                  ),
                ],
              ),
            ),

            // Quick speech simulation chips
            Container(
              height: 38,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildQuickChip('🗣️ "Kem cho bhai?"', 'Kem cho bhai, tame kon cho?'),
                  _buildQuickChip('📦 "Maro order kyare aavse?"', 'Maro order number SRT-2847 kyare aavse?'),
                  _buildQuickChip('💰 "Price shu che?"', 'Tmara service na rate ane bhav shu che?'),
                  _buildQuickChip('👤 "Tanishk bhai sathe vaat karavo"', 'Mane Tanishk bhai sathe vaat karavo urgent che'),
                  _buildQuickChip('🙏 "Aabhar bhai"', 'Theek che bhai, khub khub aabhar!'),
                ],
              ),
            ),

            // Transcript View Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  const Text('📝', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'Live Voice Transcript',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Deepgram Nova-2 + Gemini AI',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Real-time Transcript List
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF090E18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: _callService.transcript.isEmpty
                    ? Center(
                        child: Text(
                          'Connecting live call speech stream...',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.sub,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _callService.transcript.length,
                        itemBuilder: (ctx, i) {
                          final item = _callService.transcript[i];
                          return _buildTranscriptBubble(item);
                        },
                      ),
              ),
            ),

            // Live User Speech / Text Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: 'Speak or type what caller says...',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (_) => _handleSendText(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    onPressed: _handleSendText,
                    icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioStateBadge() {
    Color color;
    String label;
    IconData icon;

    switch (_callService.audioState) {
      case AudioState.speaking:
        color = AppColors.accent;
        label = 'AI Bot Speaking';
        icon = Icons.volume_up_rounded;
        break;
      case AudioState.listening:
        color = AppColors.green;
        label = 'Listening to Caller';
        icon = Icons.mic_rounded;
        break;
      case AudioState.thinking:
        color = AppColors.orange;
        label = 'AI Bot Thinking...';
        icon = Icons.psychology_rounded;
        break;
      case AudioState.idle:
        color = AppColors.sub;
        label = 'Standby';
        icon = Icons.pause_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final bg = active ? activeColor : AppColors.card;
    final fg = active ? Colors.white : AppColors.text;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: active ? activeColor : AppColors.border),
        ),
        elevation: 0,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildQuickChip(String label, String message) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: AppColors.card,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
        ),
        onPressed: () => _callService.sendCallerMessage(message),
      ),
    );
  }

  Widget _buildTranscriptBubble(dynamic item) {
    final isAi = item.isAi;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '[${item.timestamp}] ',
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.muted),
          ),
          Text(
            '${item.speaker}: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isAi ? AppColors.accent : AppColors.green,
            ),
          ),
          Expanded(
            child: Text(
              item.text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.text,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleLaunchView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Ready to Connect',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Initiate a real-time live voice call with multilingual AI reasoning (Gujarati, Hindi, English).',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.sub, height: 1.45),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Caller Profile',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<CallerProfile>(
                  value: _selectedProfile,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  dropdownColor: AppColors.card,
                  items: CallerProfile.sampleCallers.map((profile) {
                    return DropdownMenuItem(
                      value: profile,
                      child: Text(
                        '${profile.emoji} ${profile.name} (${profile.preferredLanguage})',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.text),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedProfile = val);
                  },
                ),
                const SizedBox(height: 14),
                Text(
                  'Caller Details',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sub),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090E18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(_selectedProfile.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedProfile.name,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text),
                          ),
                          Text(
                            '${_selectedProfile.phone} · ${_selectedProfile.location}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.sub),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _selectedProfile.preferredLanguage,
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFD8B4FE)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 6,
                shadowColor: AppColors.green.withValues(alpha: 0.4),
              ),
              onPressed: () {
                _callService.startCall(profile: _selectedProfile);
              },
              icon: const Icon(Icons.phone_in_talk_rounded, size: 22),
              label: Text(
                'Start Live AI Voice Call',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🎙️ Microphone and voice synthesis will automatically activate',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _CallSummaryDialog extends StatelessWidget {
  final String summary;
  final CallerProfile caller;
  final String duration;
  final VoidCallback onWhatsApp;
  final VoidCallback onRestart;

  const _CallSummaryDialog({
    required this.summary,
    required this.caller,
    required this.duration,
    required this.onWhatsApp,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Row(
        children: [
          const Text('📞', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            'Call Completed',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Call with ${caller.name} ended ($duration). Structured WhatsApp digest is ready:',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.sub),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0C241B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.wa.withValues(alpha: 0.4)),
              ),
              child: SelectableText(
                summary,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFFD1FAE5),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onRestart,
          child: Text('Start New Call', style: GoogleFonts.inter(color: AppColors.sub)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.wa,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onWhatsApp,
          icon: const Icon(Icons.send_rounded, size: 16),
          label: Text('Send to WhatsApp', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

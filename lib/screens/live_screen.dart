import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_constants.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> with SingleTickerProviderStateMixin {
  int _seconds = 134;
  late Timer _timer;
  bool _isMuted = false;
  bool _isOnHold = false;
  late AnimationController _animCtrl;

  final List<Map<String, String>> _transcript = [
    {
      'time': '00:00',
      'speaker': 'Caller',
      'text': 'Kem 6o bhai, maro order kem nathi aavyo?',
    },
    {
      'time': '00:04',
      'speaker': 'AI Bot',
      'text': 'Namaste! Tamaro order number aapi shakso?',
    },
    {
      'time': '00:09',
      'speaker': 'Caller',
      'text': 'Haa, SRT-2847',
    },
    {
      'time': '00:12',
      'speaker': 'AI Bot',
      'text': 'Tamaro order track thai rayo 6e. Aaj sanje 6 vage delivery thase.',
    },
    {
      'time': '00:19',
      'speaker': 'Caller',
      'text': 'Theek 6e, thank you bhai.',
    },
    {
      'time': '00:22',
      'speaker': 'AI Bot',
      'text': 'Swagat 6e! Bijo koi sawal 6e tame?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animCtrl.dispose();
    super.dispose();
  }

  String get _timeStr {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

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
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Live Call Monitoring',
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
              color: AppColors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fiber_manual_record, size: 10, color: AppColors.green),
                const SizedBox(width: 4),
                Text(
                  'ACTIVE',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caller Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1E36), Color(0xFF162544)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: const Center(
                      child: Text('👨', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rahul Shah',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+91 98765 43210 · Surat, Gujarat',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.sub,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: AppColors.accent),
                            const SizedBox(width: 5),
                            Text(
                              _timeStr,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '🌐 Gujarati (Auto-detected)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD8B4FE),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Audio Visualizer waveform bars (fixed height to prevent layout shaking)
                  SizedBox(
                    height: 38,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animCtrl,
                        builder: (context, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(16, (index) {
                              final wave = (1 - (_animCtrl.value - (index / 16.0)).abs()).clamp(0.2, 1.0);
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                width: 3.5,
                                height: 10 + wave * 24,
                                decoration: BoxDecoration(
                                  color: index % 2 == 0 ? AppColors.accent : AppColors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Audio & AI Controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOnHold ? AppColors.orange : AppColors.card,
                      foregroundColor: AppColors.text,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _isOnHold ? AppColors.orange : AppColors.border,
                        ),
                      ),
                    ),
                    onPressed: () => setState(() => _isOnHold = !_isOnHold),
                    icon: Icon(_isOnHold ? Icons.play_arrow : Icons.pause, size: 18),
                    label: Text(_isOnHold ? 'Resume' : 'Hold Call'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMuted ? AppColors.red : AppColors.card,
                      foregroundColor: AppColors.text,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _isMuted ? AppColors.red : AppColors.border,
                        ),
                      ),
                    ),
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                    icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, size: 18),
                    label: Text(_isMuted ? 'Unmute' : 'Mute Bot'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Real-time Transcript Section
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
                  Row(
                    children: [
                      const Text('📝', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Live Speech-to-Text Transcript',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Deepgram Nova-2',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090E18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._transcript.map((line) {
                          final isAi = line['speaker'] == 'AI Bot';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[${line['time']}] ',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '${line['speaker']}: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isAi ? AppColors.accent : AppColors.green,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    line['text'] ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Bot processing voice in real-time...',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: AppColors.sub,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live WhatsApp Summary Box
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
                  Row(
                    children: [
                      const Text('💚', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Auto WhatsApp Dispatch Preview',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C241B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.wa.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '📞 New Call Summary\n\n'
                      '👤 Name: Rahul Shah\n'
                      '📱 Contact: +91 98765 43210\n'
                      '🌐 Language: Gujarati\n'
                      '⏱ Duration: In progress ($_timeStr)\n'
                      '📋 Topic: Order delivery query (SRT-2847)\n'
                      '📝 Summary: Bot resolved delivery query. Confirmed arrival by 6 PM today.\n'
                      '✅ Action: No follow-up needed',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFD1FAE5),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

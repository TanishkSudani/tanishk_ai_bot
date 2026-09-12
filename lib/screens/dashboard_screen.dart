import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_constants.dart';
import '../widgets/stat_card.dart';
import '../widgets/live_call_card.dart';
import '../widgets/section_header.dart';
import '../widgets/call_list_tile.dart';
import 'live_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _callSec = 134;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callSec++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerStr {
    final m = (_callSec ~/ 60).toString().padLeft(2, '0');
    final s = (_callSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanishk's AI Bot",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'All systems live',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text('🔔', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                  children: const [
                    StatCard(
                      icon: '📞',
                      value: '247',
                      label: 'Calls Handled',
                      change: '↑ 18% this week',
                      accentColor: AppColors.accent,
                    ),
                    StatCard(
                      icon: '💬',
                      value: '89',
                      label: 'WA Sent to You',
                      change: '↑ 24% this week',
                      accentColor: AppColors.green,
                    ),
                    StatCard(
                      icon: '🌐',
                      value: '12',
                      label: 'Languages',
                      change: 'Gujarati #1',
                      accentColor: AppColors.purple,
                    ),
                    StatCard(
                      icon: '⚡',
                      value: '98%',
                      label: 'Uptime',
                      change: 'All systems OK',
                      accentColor: AppColors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Live Call Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LiveCallCard(
                  name: 'Rahul Shah',
                  number: '+91 98765 43210',
                  language: 'Gujarati',
                  timer: _timerStr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LiveScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Recent Activity
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Recent Activity'),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: todayCalls
                      .take(4)
                      .map(
                        (c) => CallListTile(
                          call: c,
                          isLast: c == todayCalls.take(4).last,
                          onTap: () {},
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // System Flow
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'System Flow'),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _FlowNode(icon: '📱', label: 'Caller', sub: 'Any phone', highlight: false),
                      _FlowArrow(),
                      _FlowNode(icon: '☎️', label: 'Twilio', sub: 'Route', highlight: true),
                      _FlowArrow(),
                      _FlowNode(icon: '🎤', label: 'Deepgram', sub: 'Voice→Text', highlight: false),
                      _FlowArrow(),
                      _FlowNode(icon: '🤖', label: 'Claude AI', sub: 'Understand', highlight: true),
                      _FlowArrow(),
                      _FlowNode(icon: '🔊', label: 'ElevenLabs', sub: 'Text→Voice', highlight: false),
                      _FlowArrow(),
                      _FlowNode(icon: '💚', label: 'WhatsApp', sub: 'Summary', highlight: true),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _FlowNode extends StatelessWidget {
  final String icon;
  final String label;
  final String sub;
  final bool highlight;

  const _FlowNode({
    required this.icon,
    required this.label,
    required this.sub,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppColors.muted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FlowArrow extends StatelessWidget {
  const _FlowArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '→',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

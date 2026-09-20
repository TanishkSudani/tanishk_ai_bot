import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_constants.dart';
import '../services/storage_service.dart';
import '../widgets/call_list_tile.dart';
import '../widgets/section_header.dart';
import 'chat_screen.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _storage.init().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final callsList = _storage.calls.isNotEmpty ? _storage.calls : todayCalls;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calls',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'AI handled · Real-time summaries',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.sub,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Total: ${callsList.length}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Recent & Today'),
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
                  children: callsList
                      .asMap()
                      .entries
                      .map(
                        (e) => CallListTile(
                          call: e.value,
                          isLast: e.key == callsList.length - 1,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(call: e.value),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Earlier History'),
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
                  children: yesterdayCalls
                      .asMap()
                      .entries
                      .map(
                        (e) => CallListTile(
                          call: e.value,
                          isLast: e.key == yesterdayCalls.length - 1,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(call: e.value),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
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

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/call_session_state.dart';

class LiveWaveform extends StatefulWidget {
  final AudioState audioState;
  final double height;
  final int barCount;

  const LiveWaveform({
    super.key,
    required this.audioState,
    this.height = 42,
    this.barCount = 22,
  });

  @override
  State<LiveWaveform> createState() => _LiveWaveformState();
}

class _LiveWaveformState extends State<LiveWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _getBarColor(int index) {
    switch (widget.audioState) {
      case AudioState.speaking:
        return index % 2 == 0 ? AppColors.accent : AppColors.cyan;
      case AudioState.listening:
        return index % 2 == 0 ? AppColors.green : const Color(0xFF10B981);
      case AudioState.thinking:
        return index % 2 == 0 ? AppColors.orange : AppColors.purple;
      case AudioState.idle:
        return AppColors.muted.withValues(alpha: 0.5);
    }
  }

  double _getBarHeightFactor(int index, double animValue) {
    if (widget.audioState == AudioState.idle) {
      return 0.15;
    }

    final phase = (index / widget.barCount) * 2 * math.pi;
    final speedMultiplier = widget.audioState == AudioState.thinking ? 2.0 : 1.0;
    final wave1 = math.sin((animValue * speedMultiplier * 2 * math.pi) + phase);
    final wave2 = math.cos((animValue * speedMultiplier * 4 * math.pi) - (phase * 0.5));
    final combined = ((wave1 + wave2) / 2).abs();

    if (widget.audioState == AudioState.speaking) {
      return (0.2 + (combined * 0.8)).clamp(0.2, 1.0);
    } else if (widget.audioState == AudioState.listening) {
      return (0.15 + (combined * 0.7)).clamp(0.15, 0.9);
    } else {
      // thinking
      return (0.2 + (math.sin((animValue * 4 * math.pi) + phase).abs() * 0.4)).clamp(0.2, 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (index) {
              final factor = _getBarHeightFactor(index, _ctrl.value);
              final barColor = _getBarColor(index);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.2),
                width: 3.5,
                height: math.max(6.0, widget.height * factor),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: widget.audioState != AudioState.idle
                      ? [
                          BoxShadow(
                            color: barColor.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

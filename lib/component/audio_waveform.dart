import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An animated live audio waveform visualizer that scales dynamically based on mic amplitude.
class AudioWaveform extends StatefulWidget {
  final ValueListenable<double> soundLevel;
  final bool isListening;
  final Color activeColor;
  final Color? inactiveColor;
  final int barCount;
  final double height;
  final double width;

  const AudioWaveform({
    super.key,
    required this.soundLevel,
    required this.isListening,
    required this.activeColor,
    this.inactiveColor,
    this.barCount = 7,
    this.height = 36.0,
    this.width = 110.0,
  });

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (widget.isListening) {
      _animController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _animController.repeat();
      } else {
        _animController.stop();
        _animController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final idleColor = widget.inactiveColor ?? theme.hintColor.withValues(alpha: 0.3);

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ValueListenableBuilder<double>(
        valueListenable: widget.soundLevel,
        builder: (context, level, _) {
          return AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final animVal = _animController.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(widget.barCount, (index) {
                  // Bell curve multiplier (center bars are tallest)
                  final double bellFactor = sin((index + 1) / (widget.barCount + 1) * pi);

                  // Subtle oscillating phase per bar for fluid movement
                  final double phase = (index / widget.barCount) * 2 * pi;
                  final double oscillation = (sin(animVal * 2 * pi + phase) + 1.0) / 2.0;

                  double barHeight;
                  Color barColor;

                  if (widget.isListening) {
                    // Combine microphone decibel level with wave oscillation
                    final double intensity = (level * 0.75 + oscillation * 0.25).clamp(0.08, 1.0);
                    barHeight = (4.0 + (widget.height - 4.0) * intensity * bellFactor)
                        .clamp(4.0, widget.height);
                    barColor = widget.activeColor;
                  } else {
                    // Resting state
                    barHeight = 4.0 + (bellFactor * 4.0);
                    barColor = idleColor;
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.easeOutCubic,
                    width: (widget.width / (widget.barCount * 1.8)).clamp(3.0, 6.0),
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Radar — Audio Providers
// Rust bridge not yet wired; processAudio is a placeholder identity function.
// ─────────────────────────────────────────────────────────────────────────────

// Whether the app is currently recording microphone input.
final recordingStateProvider = StateProvider<bool>((ref) => false);

// Most recent measured round-trip latency in milliseconds. Null before first chunk.
final latencyProvider = StateProvider<double?>((ref) => null);

// Rolling buffer of the last 100 normalized audio samples (−1.0 … 1.0).
final waveformBufferProvider = StateProvider<List<double>>((ref) => List.filled(100, 0.0));

// Number of audio chunks processed in the last second.
final chunksPerSecondProvider = StateProvider<int>((ref) => 0);

// Whether the bypass (passthrough without processing) mode is active.
final bypassActiveProvider = StateProvider<bool>((ref) => false);

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder audio processing pipeline
// ─────────────────────────────────────────────────────────────────────────────

/// Simulates an audio processing step. Returns samples unchanged (identity).
/// Measures wall-clock latency and exposes it via [latencyProvider].
///
/// Replace the body of this function with the real flutter_rust_bridge call
/// once the native DSP library is wired up.
Future<List<double>> processAudio(
  List<double> samples,
  Ref ref,
) async {
  final sw = Stopwatch()..start();

  // ── Placeholder: 2 ms simulated processing delay ─────────────────────────
  await Future.delayed(const Duration(milliseconds: 2));
  // FUTURE: replace with → final processed = await rustBridge.processAudio(samples);
  final processed = samples; // identity — returns input unchanged
  // ─────────────────────────────────────────────────────────────────────────

  sw.stop();
  final latencyMs = sw.elapsedMicroseconds / 1000.0;

  // Push latency measurement to UI
  ref.read(latencyProvider.notifier).state = latencyMs;

  // Update rolling waveform buffer (keep last 100 samples)
  final current = List<double>.from(ref.read(waveformBufferProvider));
  current.addAll(processed);
  if (current.length > 100) {
    ref.read(waveformBufferProvider.notifier).state =
        current.sublist(current.length - 100);
  } else {
    ref.read(waveformBufferProvider.notifier).state = current;
  }

  // Increment chunk counter
  ref.read(chunksPerSecondProvider.notifier).state++;

  return processed;
}

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Radar — Audio Providers
// Rust bridge not yet wired; processAudio is a placeholder identity function.
// ─────────────────────────────────────────────────────────────────────────────

// Whether the app is currently recording microphone input.
final recordingStateProvider = StateProvider<bool>((ref) => false);

// Most recent measured round-trip latency in milliseconds. Null before first chunk.
final latencyProvider = StateProvider<double?>((ref) => null);

// The buffer size (in samples) measured from the real stream chunk.
final bufferSizeProvider = StateProvider<int?>((ref) => null);

// ─────────────────────────────────────────────────────────────────────────────
// Denoiser Providers
// ─────────────────────────────────────────────────────────────────────────────

class ImportedMedia {
  final String path;
  final String name;
  final String extension;
  final String details;

  ImportedMedia({
    required this.path,
    required this.name,
    required this.extension,
    required this.details,
  });
}

final importedFileProvider = StateProvider<ImportedMedia?>((ref) => null);
final noiseRegionProvider = StateProvider<List<double>>((ref) => [0.45, 1.22]);
final alphaValueProvider = StateProvider<double>((ref) => 0.5);
final denoiseProgressProvider = StateProvider<double>((ref) => 0.0);
final reductionDepthProvider = StateProvider<double>((ref) => -12.4);
final denoiserModeProvider = StateProvider<String>((ref) => "Raw");
final isComputingProfileProvider = StateProvider<bool>((ref) => false);
final isDenoisingFileProvider = StateProvider<bool>((ref) => false);

// The real input device name from hardware.
final inputDeviceProvider = FutureProvider<String>((ref) async {
  final recorder = AudioRecorder();
  final devices = await recorder.listInputDevices();
  if (devices.isNotEmpty) {
    return devices.first.label.isNotEmpty
        ? devices.first.label
        : devices.first.id;
  }
  return "DEFAULT MIC";
});

// Audio pipeline controller to manage the microphone stream and feed it to processAudio.
class AudioPipelineController extends Notifier<void> {
  final _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _subscription;

  @override
  void build() {
    ref.listen<bool>(recordingStateProvider, (prev, isRecord) {
      if (isRecord) {
        _start();
      } else {
        _stop();
      }
    });

    ref.onDispose(() {
      _stop();
      _recorder.dispose();
    });
  }

  Future<void> _start() async {
    if (await _recorder.hasPermission()) {
      final stream = await _recorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      ));

      var isFirst = true;

      _subscription = stream.listen((chunk) async {
        if (isFirst) {
          final sampleCount = chunk.length ~/ 2;
          ref.read(bufferSizeProvider.notifier).state = sampleCount;
          isFirst = false;
        }

        // Pass dummy samples containing 0.0s since Rust is not integrated yet
        final samples = List.filled(chunk.length ~/ 2, 0.0);
        await processAudio(samples, ref);
      });
    } else {
      ref.read(recordingStateProvider.notifier).state = false;
    }
  }

  Future<void> _stop() async {
    await _subscription?.cancel();
    _subscription = null;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }
}

final audioPipelineControllerProvider =
    NotifierProvider<AudioPipelineController, void>(() {
  return AudioPipelineController();
});

// Rolling buffer of the last 100 normalized audio samples (−1.0 … 1.0).
final waveformBufferProvider =
    StateProvider<List<double>>((ref) => List.filled(100, 0.0));

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
  final sw = Stopwatch();
  sw.start();

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

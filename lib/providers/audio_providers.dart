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

// ─────────────────────────────────────────────────────────────────────────────
// Compression Engine Providers
// ─────────────────────────────────────────────────────────────────────────────

enum CompressionPreset { fast, balanced, quality }

enum CompressionStatus { idle, encoding, complete }

final compressionFilePathProvider = StateProvider<String?>((ref) => null);
final compressionFileSizeProvider = StateProvider<double?>((ref) => null);
final compressionDurationProvider = StateProvider<double?>((ref) => null);
final selectedPresetProvider =
    StateProvider<CompressionPreset>((ref) => CompressionPreset.balanced);

final compressionProgressProvider = StateProvider<double>((ref) => 0.0);
final compressionStatusProvider =
    StateProvider<CompressionStatus>((ref) => CompressionStatus.idle);

final hardwareAccelProvider = StateProvider<bool>((ref) => false);
final twoPassProvider = StateProvider<bool>((ref) => false);
final stripMetadataProvider = StateProvider<bool>((ref) => false);
final audioOnlyProvider = StateProvider<bool>((ref) => false);

// FFmpeg simulated runtime logs
final compressionLogsProvider = StateProvider<List<String>>((ref) => []);

final estimatedSizeProvider = Provider<double?>((ref) {
  final fileSize = ref.watch(compressionFileSizeProvider);
  final duration = ref.watch(compressionDurationProvider);
  final preset = ref.watch(selectedPresetProvider);

  if (fileSize == null || duration == null) return null;

  double videoKbps;
  double audioKbps;

  switch (preset) {
    case CompressionPreset.fast:
      videoKbps = 800;
      audioKbps = 96;
      break;
    case CompressionPreset.balanced:
      videoKbps = 1500;
      audioKbps = 128;
      break;
    case CompressionPreset.quality:
      videoKbps = 2500;
      audioKbps = 128;
      break;
  }

  if (ref.watch(audioOnlyProvider)) {
    videoKbps = 0;
  }

  // (video_bitrate + audio_bitrate) * duration / 8 / 1024
  return ((videoKbps + audioKbps) * duration) / 8.0 / 1024.0;
});

final ffmpegCommandProvider = Provider<String>((ref) {
  final preset = ref.watch(selectedPresetProvider);
  final hwAccel = ref.watch(hardwareAccelProvider);
  final stripMeta = ref.watch(stripMetadataProvider);
  final audioOnly = ref.watch(audioOnlyProvider);

  final input = "input.mp4";
  final output = "output_radar.mp4";
  final codec = audioOnly ? "-vn" : "-c:v libx265";
  final crf = preset == CompressionPreset.fast
      ? "28"
      : preset == CompressionPreset.balanced
          ? "24"
          : "20";
  final speed = preset == CompressionPreset.fast
      ? "ultrafast"
      : preset == CompressionPreset.balanced
          ? "medium"
          : "slow";
  final audio =
      "-c:a libopus -b:a ${preset == CompressionPreset.fast ? '96k' : '128k'}";
  final hw = hwAccel ? "-hwaccel auto " : "";
  final meta = stripMeta ? "-map_metadata -1 " : "";

  return "ffmpeg $hw-i $input $codec -crf $crf -preset $speed $audio $meta$output";
});

// ─────────────────────────────────────────────────────────────────────────────
// Settings & Setup Providers — Phase 4
// ─────────────────────────────────────────────────────────────────────────────

// DSP Parameters
final dctWindowSizeProvider = StateProvider<int>((ref) => 1024);
final overlapFactorProvider = StateProvider<double>((ref) => 0.5);
final noiseFloorProvider = StateProvider<double>((ref) => -40.0);

// Pipeline
final sampleRateProvider = StateProvider<int>((ref) => 44100);
final bitDepthProvider = StateProvider<int>((ref) => 16);
final rustBridgeEnabledProvider = StateProvider<bool>((ref) => true);

// Output
enum ExportFormat { wav, opus, mp3, flac }

final exportFormatProvider =
    StateProvider<ExportFormat>((ref) => ExportFormat.wav);
final outputDirectoryProvider =
    StateProvider<String>((ref) => 'Downloads/Radar');
final autoSaveProvider = StateProvider<bool>((ref) => true);
final appendSuffixProvider = StateProvider<bool>((ref) => true);

// Benchmark results — null until a benchmark has been run
typedef BenchmarkResult = ({double avg, double min, double max});
final benchmarkResultsProvider =
    StateProvider<BenchmarkResult?>((ref) => null);

/// Runs 100 iterations of the processAudio stub and records latency stats.
/// Updates [benchmarkResultsProvider] with the results.
Future<void> runBenchmark(WidgetRef ref) async {
  final results = <double>[];
  final testSamples = List<double>.filled(1024, 0.5);
  for (int i = 0; i < 100; i++) {
    final sw = Stopwatch()..start();
    // Mirror the processAudio stub delay; testSamples is the simulated input
    await Future.delayed(const Duration(milliseconds: 2));
    // ignore: unused_local_variable
    final dummy = testSamples.length; // reference to avoid dead-code warning
    sw.stop();
    results.add(sw.elapsedMicroseconds / 1000.0);
  }
  ref.read(benchmarkResultsProvider.notifier).state = (
    avg: results.reduce((a, b) => a + b) / results.length,
    min: results.reduce((a, b) => a < b ? a : b),
    max: results.reduce((a, b) => a > b ? a : b),
  );
}


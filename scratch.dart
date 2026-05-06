import 'package:record/record.dart';

void main() async {
  final record = AudioRecorder();
  final devices = await record.listInputDevices();
  print(devices.map((d) => d.label).toList());
}

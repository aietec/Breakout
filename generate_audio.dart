import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void writeWav(String filename, List<double> samples) {
  int sampleRate = 44100;
  int channels = 1;
  int byteRate = sampleRate * channels * 2;
  int dataSize = samples.length * 2;
  
  var file = File('assets/audio/$filename');
  var builder = BytesBuilder();
  
  // RIFF header
  builder.add('RIFF'.codeUnits);
  builder.add(_int32(36 + dataSize));
  builder.add('WAVE'.codeUnits);
  
  // fmt chunk
  builder.add('fmt '.codeUnits);
  builder.add(_int32(16));
  builder.add(_int16(1)); // PCM
  builder.add(_int16(channels));
  builder.add(_int32(sampleRate));
  builder.add(_int32(byteRate));
  builder.add(_int16(channels * 2));
  builder.add(_int16(16)); // 16 bits per sample
  
  // data chunk
  builder.add('data'.codeUnits);
  builder.add(_int32(dataSize));
  
  for (var s in samples) {
    int v = (s * 32767).toInt().clamp(-32768, 32767);
    builder.add(_int16(v));
  }
  
  file.writeAsBytesSync(builder.toBytes());
  print('Generated $filename');
}

List<int> _int16(int v) => [v & 0xff, (v >> 8) & 0xff];
List<int> _int32(int v) => [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff];

List<double> generateTone(double startFreq, double endFreq, double durationSec, {bool isSquare = true}) {
  int sampleRate = 44100;
  int totalSamples = (sampleRate * durationSec).toInt();
  List<double> samples = [];
  double phase = 0;
  for (int i = 0; i < totalSamples; i++) {
    double t = i / totalSamples;
    double freq = startFreq + (endFreq - startFreq) * t;
    phase += 2 * pi * freq / sampleRate;
    double sample = isSquare ? (sin(phase) > 0 ? 0.3 : -0.3) : sin(phase) * 0.5;
    
    // Envelope to avoid clicks
    double env = 1.0;
    if (i < 500) env = i / 500;
    if (i > totalSamples - 500) env = (totalSamples - i) / 500;
    
    samples.add(sample * env);
  }
  return samples;
}

List<double> generateArpeggio(List<double> freqs, double durationSec, {bool isSquare = true}) {
  int sampleRate = 44100;
  int totalSamples = (sampleRate * durationSec).toInt();
  int samplesPerNote = totalSamples ~/ freqs.length;
  List<double> samples = [];
  
  for (int j = 0; j < freqs.length; j++) {
    double freq = freqs[j];
    double phase = 0;
    for (int i = 0; i < samplesPerNote; i++) {
      phase += 2 * pi * freq / sampleRate;
      double sample = isSquare ? (sin(phase) > 0 ? 0.3 : -0.3) : sin(phase) * 0.5;
      
      double env = 1.0;
      if (i < 500) env = i / 500;
      if (i > samplesPerNote - 500) env = (samplesPerNote - i) / 500;
      
      samples.add(sample * env);
    }
  }
  return samples;
}

void main() {
  Directory('assets/audio').createSync(recursive: true);
  
  // hit_paddle.wav : bip court mat (150 Hz, 80 ms)
  writeWav('hit_paddle.wav', generateTone(150, 150, 0.08, isSquare: true));
  
  // hit_wall.wav : bip aigu (400 Hz, 60 ms)
  writeWav('hit_wall.wav', generateTone(400, 400, 0.06, isSquare: true));
  
  // hit_brick.wav : blip arcade (600 Hz vers 800 Hz, 100 ms)
  writeWav('hit_brick.wav', generateTone(600, 800, 0.1, isSquare: true));
  
  // lose_life.wav : tonalité descendante (300 Hz vers 100 Hz, 400 ms)
  writeWav('lose_life.wav', generateTone(300, 100, 0.4, isSquare: true));
  
  // level_win.wav : arpège ascendant (400 Hz, 550 Hz, 700 Hz, 500 ms)
  writeWav('level_win.wav', generateArpeggio([400, 550, 700], 0.5, isSquare: true));
  
  // bgm.wav : petit jingle en boucle
  writeWav('bgm.wav', generateArpeggio([200, 250, 300, 250], 0.8, isSquare: false));
}


import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _initialized = false;
  static final double _musicVolume = 0.5;
  static final double _sfxVolume = 1.0;
  static final Set<String> _loadedFiles = {};

  static Future<void> init() async {
    if (_initialized) return;
    
    final filesToLoad = [
      'bounce.wav', 'paddle.wav', 'brick.wav', 'lose.wav', 'win.wav', 'wall.wav', 'music.mp3',
      'brick_yellow.wav', 'brick_green.wav', 'brick_orange.wav', 'brick_red.wav'
    ];

    for (final file in filesToLoad) {
      try {
        await FlameAudio.audioCache.load(file);
        _loadedFiles.add(file);
      } catch (e) {
        // Silently ignore missing files to avoid crashes
        print('Audio file not found or failed to load: $file');
      }
    }
    
    _initialized = true;
  }

  static void playSfx(String file) {
    if (!_initialized) return;
    
    String fileToPlay = file;
    if (!_loadedFiles.contains(fileToPlay)) {
      // Fallback for bricks if specific color is missing
      if (fileToPlay.startsWith('brick_') && _loadedFiles.contains('brick.wav')) {
        fileToPlay = 'brick.wav';
      } else if (fileToPlay == 'wall.wav' && _loadedFiles.contains('bounce.wav')) {
        fileToPlay = 'bounce.wav';
      } else {
        return; // Silent fallback
      }
    }

    try {
      FlameAudio.play(fileToPlay, volume: _sfxVolume);
    } catch (e) {
      print('Sfx error: $e');
    }
  }

  static void playMusic(String file) {
    if (!_initialized) return;
    if (!_loadedFiles.contains(file)) return;
    try {
      FlameAudio.bgm.play(file, volume: _musicVolume);
    } catch (e) {
      print('Music error: $e');
    }
  }
}

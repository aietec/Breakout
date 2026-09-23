
import 'package:flame_audio/flame_audio.dart';

import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _initialized = false;
  static double _musicVolume = 0.5;
  static double _sfxVolume = 1.0;
  static bool _isMusicEnabled = true;
  static bool _isSfxEnabled = true;
  
  static final Set<String> _loadedFiles = {};

  static Future<void> init() async {
    if (_initialized) return;
    
    final filesToLoad = [
      'hit_paddle.wav', 'hit_wall.wav', 'hit_brick.wav', 'lose_life.wav', 'level_win.wav', 'bgm.wav'
    ];

    for (final file in filesToLoad) {
      try {
        await FlameAudio.audioCache.load(file);
        _loadedFiles.add(file);
      } catch (e) {
        print('Audio file not found or failed to load: $file');
      }
    }
    
    _initialized = true;
  }

  static void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopMusic();
    }
  }

  static void setSfxEnabled(bool enabled) {
    _isSfxEnabled = enabled;
  }

  static void setMusicVolume(double volume) {
    _musicVolume = volume;
    FlameAudio.bgm.audioPlayer?.setVolume(volume);
  }

  static void setSfxVolume(double volume) {
    _sfxVolume = volume;
  }

  static void playSfx(String file) {
    if (!_initialized || !_isSfxEnabled) return;
    
    if (!_loadedFiles.contains(file)) {
      return; // Silent fallback
    }

    try {
      FlameAudio.play(file, volume: _sfxVolume);
    } catch (e) {
      print('Sfx error: $e');
    }
  }

  static void playMusic(String file) {
    if (!_initialized || !_isMusicEnabled) return;
    if (!_loadedFiles.contains(file)) return;
    try {
      FlameAudio.bgm.play(file, volume: _musicVolume);
    } catch (e) {
      print('Music error: $e');
    }
  }

  static void stopMusic() {
    if (!_initialized) return;
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      print('Stop music error: $e');
    }
  }
}

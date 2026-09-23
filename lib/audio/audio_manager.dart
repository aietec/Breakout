
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager extends ChangeNotifier {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool _initialized = false;
  double _musicVolume = 0.5;
  double _sfxVolume = 1.0;
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  
  final Set<String> _loadedFiles = {};

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  static AudioManager get instance => _instance;

  static Future<void> init() async {
    if (_instance._initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _instance._isMusicEnabled = prefs.getBool('isMusicEnabled') ?? true;
    _instance._isSfxEnabled = prefs.getBool('isSfxEnabled') ?? true;
    _instance._musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
    _instance._sfxVolume = prefs.getDouble('sfxVolume') ?? 1.0;
    
    final filesToLoad = [
      'hit_paddle.wav', 'hit_wall.wav', 'hit_brick.wav', 'lose_life.wav', 'level_win.wav', 'bgm.wav'
    ];

    for (final file in filesToLoad) {
      try {
        await FlameAudio.audioCache.load(file);
        _instance._loadedFiles.add(file);
      } catch (e) {
        print('Audio file not found or failed to load: $file');
      }
    }
    
    _instance._initialized = true;
    _instance.notifyListeners();
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    _instance._isMusicEnabled = enabled;
    if (!enabled) {
      stopMusic();
    } else {
      playMusic('bgm.wav');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMusicEnabled', enabled);
    _instance.notifyListeners();
  }

  static Future<void> setSfxEnabled(bool enabled) async {
    _instance._isSfxEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSfxEnabled', enabled);
    _instance.notifyListeners();
  }

  static Future<void> setMusicVolume(double volume) async {
    _instance._musicVolume = volume;
    FlameAudio.bgm.audioPlayer?.setVolume(volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', volume);
    _instance.notifyListeners();
  }

  static Future<void> setSfxVolume(double volume) async {
    _instance._sfxVolume = volume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sfxVolume', volume);
    _instance.notifyListeners();
  }

  static void playSfx(String file) {
    if (!_instance._initialized || !_instance._isSfxEnabled) return;
    if (!_instance._loadedFiles.contains(file)) return;
    try {
      FlameAudio.play(file, volume: _instance._sfxVolume);
    } catch (e) {
      print('Sfx error: $e');
    }
  }

  static void playMusic(String file) {
    if (!_instance._initialized || !_instance._isMusicEnabled) return;
    if (!_instance._loadedFiles.contains(file)) return;
    try {
      FlameAudio.bgm.play(file, volume: _instance._musicVolume);
    } catch (e) {
      print('Music error: $e');
    }
  }

  static void stopMusic() {
    if (!_instance._initialized) return;
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      print('Stop music error: $e');
    }
  }
}

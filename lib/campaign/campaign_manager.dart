import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/models/campaign_progress.dart';
import '../shared/models/game_snapshot.dart';
import '../shared/models/level_data.dart';

class CampaignManager {
  static const String _progressKey = 'campaign_progress';
  static const String _snapshotKey = 'campaign_snapshot';

  Future<CampaignProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString != null) {
      try {
        return CampaignProgress.fromJsonString(jsonString);
      } catch (e) {
        // Fallback to new progress if corrupted
        return CampaignProgress();
      }
    }
    return CampaignProgress();
  }

  Future<void> saveProgress(CampaignProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, progress.toJsonString());
  }

  Future<void> updateLevelProgress({
    required int world,
    required int level,
    required String levelId,
    required int stars,
    required int score,
  }) async {
    final progress = await loadProgress();

    // Check if new highest level
    int newHighestWorld = progress.highestWorldUnlocked;
    int newHighestLevel = progress.highestLevelUnlocked;

    if (world == newHighestWorld && level == newHighestLevel) {
      if (level < 12) {
        newHighestLevel++;
      } else {
        newHighestWorld++;
        newHighestLevel = 1;
      }
    } else if (world > newHighestWorld) {
      newHighestWorld = world;
      newHighestLevel = level;
    }

    final newStarsMap = Map<String, int>.from(progress.starsPerLevel);
    if ((newStarsMap[levelId] ?? 0) < stars) {
      newStarsMap[levelId] = stars;
    }

    final newScoreMap = Map<String, int>.from(progress.bestScorePerLevel);
    if ((newScoreMap[levelId] ?? 0) < score) {
      newScoreMap[levelId] = score;
    }

    final newProgress = CampaignProgress(
      highestWorldUnlocked: newHighestWorld,
      highestLevelUnlocked: newHighestLevel,
      starsPerLevel: newStarsMap,
      bestScorePerLevel: newScoreMap,
    );

    await saveProgress(newProgress);
  }

  Future<LevelData> loadLevel(int world, int level) async {
    final String path = 'assets/levels/level_${world}_${level}.json';
    final String jsonString = await rootBundle.loadString(path);
    return LevelData.fromJsonString(jsonString);
  }

  Future<void> saveSnapshot(GameSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_snapshotKey, snapshot.toJsonString());
  }

  Future<GameSnapshot?> loadSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_snapshotKey);
    if (jsonString != null) {
      try {
        return GameSnapshot.fromJsonString(jsonString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_snapshotKey);
  }
}

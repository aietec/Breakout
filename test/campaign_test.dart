import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakout/campaign/campaign_manager.dart';
import 'package:breakout/shared/models/campaign_progress.dart';
import 'package:breakout/shared/models/game_snapshot.dart';
import 'package:breakout/shared/models/level_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CampaignManager and Models', () {
    late CampaignManager manager;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      manager = CampaignManager();
    });

    test('Loads default progress when empty', () async {
      final progress = await manager.loadProgress();
      expect(progress.highestWorldUnlocked, 1);
      expect(progress.highestLevelUnlocked, 1);
      expect(progress.starsPerLevel.isEmpty, true);
    });

    test('Saves and loads progress correctly', () async {
      final progress = CampaignProgress(
        highestWorldUnlocked: 2,
        highestLevelUnlocked: 3,
        starsPerLevel: {'1-1': 3, '1-2': 2},
        bestScorePerLevel: {'1-1': 500},
      );

      await manager.saveProgress(progress);
      final loaded = await manager.loadProgress();

      expect(loaded.highestWorldUnlocked, 2);
      expect(loaded.highestLevelUnlocked, 3);
      expect(loaded.starsPerLevel['1-1'], 3);
      expect(loaded.bestScorePerLevel['1-1'], 500);
    });

    test('Updates level progress correctly', () async {
      await manager.updateLevelProgress(
        world: 1,
        level: 1,
        levelId: '1-1',
        stars: 3,
        score: 1500,
      );

      var progress = await manager.loadProgress();
      expect(progress.highestLevelUnlocked, 2);
      expect(progress.starsPerLevel['1-1'], 3);

      // Should not unlock beyond 1-2 if playing an old level
      await manager.updateLevelProgress(
        world: 1,
        level: 1,
        levelId: '1-1',
        stars: 3,
        score: 1600,
      );
      progress = await manager.loadProgress();
      expect(progress.highestLevelUnlocked, 2);
    });

    test('Saves and loads snapshot correctly', () async {
      final snapshot = GameSnapshot(
        level: LevelData(
          id: '1-1', world: 1, level: 1, name: 'T', initialSpeed: 300,
          objectives: LevelObjectives(timeTarget: 100, livesTarget: 2),
          grid: [[1, 2]]
        ),
        score: 50,
        lives: 2,
        bricksDestroyed: 5,
        paddleX: 100.5,
        ballX: 50.0,
        ballY: 60.0,
        ballVX: 10.0,
        ballVY: -10.0,
      );

      await manager.saveSnapshot(snapshot);
      final loaded = await manager.loadSnapshot();

      expect(loaded, isNotNull);
      expect(loaded!.score, 50);
      expect(loaded.ballX, 50.0);
      expect(loaded.level.id, '1-1');

      await manager.clearSnapshot();
      final cleared = await manager.loadSnapshot();
      expect(cleared, isNull);
    });
  });
}

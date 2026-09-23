import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakout/campaign/campaign_manager.dart';
import 'package:breakout/game/game_state.dart';
import 'package:breakout/game/components/brick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Campaign level 1-1 loads and finishes successfully', () async {
    final manager = CampaignManager();
    // Simulate playing and finishing level 1-1
    final levelData = await manager.loadLevel(1, 1);
    expect(levelData.id, isNotNull);
    
    // Simulate game state
    final gameState = GameState();
    
    // Level 1-1 has 21 bricks (or something similar depending on the file)
    // We just simulate destroying a few bricks and finishing the game
    int score = 0;
    
    // Let's check how many bricks are in level 1-1
    int totalBricks = 0;
    for (var row in levelData.grid) {
      for (var cell in row) {
        if (cell != 0 && cell != 9 && cell != 10) {
          totalBricks++;
        }
      }
    }
    
    // Destroy all bricks
    for (int i = 0; i < totalBricks; i++) {
      gameState.onBrickDestroyed(BrickColor.yellow);
    }
    
    // Ensure the score is computed
    expect(gameState.score, greaterThan(0));
    
    // Save progress
    await manager.updateLevelProgress(
      world: 1, 
      level: 1, 
      levelId: levelData.id, 
      stars: 3, 
      score: gameState.score,
    );
    
    // Verify progress is saved
    final progress = await manager.loadProgress();
    expect(progress.highestWorldUnlocked, 1);
    expect(progress.highestLevelUnlocked, 2);
    expect(progress.starsPerLevel[levelData.id], 3);
    
    print('Campaign Level 1-1 simulated successfully.');
    print('Score obtained: \${gameState.score}');
    print('Next unlocked level: \${progress.highestWorldUnlocked}-\${progress.highestLevelUnlocked}');
  });
}

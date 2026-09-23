import 'package:flutter_test/flutter_test.dart';
import 'package:breakout/game/game_state.dart';

void main() {
  group('GameState', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState();
    });

    test('Initial state is correct', () {
      expect(gameState.score, 0);
      expect(gameState.lives, 3);
      expect(gameState.currentScreen, 1);
      expect(gameState.speedMultiplier, 1.0);
    });

    test('Score increments correctly based on brick color', () {
      gameState.onBrickDestroyed(BrickColor.yellow);
      expect(gameState.score, 1);

      gameState.onBrickDestroyed(BrickColor.green);
      expect(gameState.score, 4);

      gameState.onBrickDestroyed(BrickColor.orange);
      expect(gameState.score, 9);

      gameState.onBrickDestroyed(BrickColor.red);
      expect(gameState.score, 16);
    });

    test('Speed increases monotonically and resets on new ball', () {
      expect(gameState.speedMultiplier, 1.0);

      // Hit 3 yellow bricks (no speed increase)
      for (int i = 0; i < 3; i++) {
        gameState.onBrickDestroyed(BrickColor.yellow);
      }
      expect(gameState.speedMultiplier, 1.0);

      // 4th brick destroyed -> V2
      gameState.onBrickDestroyed(BrickColor.yellow);
      expect(gameState.speedMultiplier, closeTo(1.15, 0.001));

      // 12th brick destroyed -> V3
      for (int i = 0; i < 8; i++) {
        gameState.onBrickDestroyed(BrickColor.yellow);
      }
      expect(gameState.speedMultiplier, closeTo(1.30, 0.001));

      // Orange or red brick -> V4
      gameState.onBrickDestroyed(BrickColor.orange);
      expect(gameState.speedMultiplier, closeTo(1.50, 0.001));

      // Cannot decrease
      gameState.onBrickDestroyed(BrickColor.yellow);
      expect(gameState.speedMultiplier, closeTo(1.50, 0.001));

      // Reset on new ball
      gameState.resetBallState();
      expect(gameState.speedMultiplier, 1.0);
    });

    test('Paddle shrinks only on top wall hit and restores on new ball', () {
      expect(gameState.paddleShrunk, false);

      // Top wall hit triggers shrink
      bool shrinkTrigger = gameState.onTopWallHit();
      expect(shrinkTrigger, true);
      expect(gameState.paddleShrunk, true);

      // Second hit doesn't trigger again
      shrinkTrigger = gameState.onTopWallHit();
      expect(shrinkTrigger, false);
      expect(gameState.paddleShrunk, true);

      // New ball restores
      gameState.resetBallState();
      expect(gameState.paddleShrunk, false);
    });

    test('Max score for one screen is 448, and transition to second screen works', () {
      bool generatedNext = false;
      for (int i = 0; i < 28; i++) { generatedNext = gameState.onBrickDestroyed(BrickColor.yellow); }
      for (int i = 0; i < 28; i++) { generatedNext = gameState.onBrickDestroyed(BrickColor.green); }
      for (int i = 0; i < 28; i++) { generatedNext = gameState.onBrickDestroyed(BrickColor.orange); }
      for (int i = 0; i < 27; i++) { generatedNext = gameState.onBrickDestroyed(BrickColor.red); }

      expect(gameState.score, 441);
      expect(generatedNext, false);

      generatedNext = gameState.onBrickDestroyed(BrickColor.red);
      expect(gameState.score, 448);
      expect(generatedNext, true);
      expect(gameState.currentScreen, 2);
    });

    test('No third screen generated after second screen', () {
      // Screen 1
      for (int i = 0; i < 112; i++) { gameState.onBrickDestroyed(BrickColor.yellow); }
      expect(gameState.currentScreen, 2);

      // Screen 2
      bool generatedNext = false;
      for (int i = 0; i < 111; i++) { generatedNext = gameState.onBrickDestroyed(BrickColor.yellow); }
      expect(generatedNext, false);
      
      generatedNext = gameState.onBrickDestroyed(BrickColor.yellow);
      expect(generatedNext, false); // No third screen
      expect(gameState.currentScreen, 3);
      
      // Additional hits don't give score if screen > maxScreens
      int prevScore = gameState.score;
      gameState.onBrickDestroyed(BrickColor.red);
      expect(gameState.score, prevScore);
    });
  });
}

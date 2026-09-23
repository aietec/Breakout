import 'package:flutter_test/flutter_test.dart';
import 'package:breakout/game/game_state.dart';

void main() {
  group('Classic Mode Rules Test', () {
    late GameState state;

    setUp(() {
      state = GameState();
    });

    test('Score calculation for 1 screen = 448 pts', () {
      for (int i = 0; i < 28; i++) state.onBrickDestroyed(BrickColor.yellow);
      for (int i = 0; i < 28; i++) state.onBrickDestroyed(BrickColor.green);
      for (int i = 0; i < 28; i++) state.onBrickDestroyed(BrickColor.orange);
      
      expect(state.score, equals(28 * 1 + 28 * 3 + 28 * 5)); // 252
      expect(state.currentScreen, equals(1));
      
      for (int i = 0; i < 27; i++) state.onBrickDestroyed(BrickColor.red);
      expect(state.currentScreen, equals(1));
      
      bool nextScreen = state.onBrickDestroyed(BrickColor.red);
      expect(state.score, equals(448));
      expect(nextScreen, isTrue);
      expect(state.currentScreen, equals(2));
      expect(state.screenBricksDestroyed, equals(0));
    });

    test('Score calculation for 2 screens = 896 pts max and no 3rd screen', () {
      // Screen 1
      for (int i = 0; i < 112; i++) {
        state.onBrickDestroyed(BrickColor.yellow); // 1 pt each
      }
      expect(state.currentScreen, equals(2));
      
      // Screen 2
      for (int i = 0; i < 111; i++) {
        state.onBrickDestroyed(BrickColor.yellow);
      }
      expect(state.currentScreen, equals(2));
      
      bool nextScreen = state.onBrickDestroyed(BrickColor.yellow);
      expect(nextScreen, isFalse);
      expect(state.currentScreen, equals(3)); // Means game is won
    });

    test('Paddle shrinks only after breaking red and hitting top wall', () {
      expect(state.paddleShrunk, isFalse);
      
      // Hit top wall without breaking red
      bool shrinkTriggered = state.onTopWallHit();
      expect(shrinkTriggered, isFalse);
      expect(state.paddleShrunk, isFalse);

      // Break a red brick
      state.onBrickDestroyed(BrickColor.red);
      expect(state.hasHitRed, isTrue);
      
      // Hit top wall again
      shrinkTriggered = state.onTopWallHit();
      expect(shrinkTriggered, isTrue);
      expect(state.paddleShrunk, isTrue);
      
      // A subsequent hit shouldn't trigger another shrink
      shrinkTriggered = state.onTopWallHit();
      expect(shrinkTriggered, isFalse);
    });

    test('Speed increments trigger correctly over the game', () {
      expect(state.speedLevel, equals(0));
      
      // 1 to 3 bricks
      for (int i = 0; i < 3; i++) state.onBrickDestroyed(BrickColor.yellow);
      expect(state.speedLevel, equals(0));
      
      // 4th brick
      state.onBrickDestroyed(BrickColor.yellow);
      expect(state.speedLevel, equals(1));
      
      // Up to 11 bricks
      for (int i = 0; i < 7; i++) state.onBrickDestroyed(BrickColor.yellow);
      expect(state.speedLevel, equals(1));
      
      // 12th brick
      state.onBrickDestroyed(BrickColor.yellow);
      expect(state.speedLevel, equals(2));
      
      // Hit Orange
      state.onBrickDestroyed(BrickColor.orange);
      expect(state.speedLevel, equals(3));
      
      // Simulate ball reset, speed must persist!
      state.resetBallState();
      expect(state.speedLevel, equals(3));
    });

    test('3 lives strict game over', () {
      expect(state.lives, equals(3));
      
      bool gameOver = state.onBallLost();
      expect(gameOver, isFalse);
      expect(state.lives, equals(2));
      
      gameOver = state.onBallLost();
      expect(gameOver, isFalse);
      expect(state.lives, equals(1));
      
      gameOver = state.onBallLost();
      expect(gameOver, isTrue);
      expect(state.lives, equals(0));
    });
  });
}

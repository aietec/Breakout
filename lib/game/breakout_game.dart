import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'components/paddle.dart';
import 'components/ball.dart';
import 'components/brick.dart';
import 'components/effect_zone.dart';
import 'game_state.dart';
import '../audio/audio_manager.dart';
import '../app/screens/campaign_menu.dart';
import '../shared/models/level_data.dart';

class BreakoutGame extends FlameGame with HasCollisionDetection, DragCallbacks {
  final LevelData? levelData;
  final GameDifficulty difficulty;
  final Function(int score, int stars)? onLevelCompleted;

  late Paddle paddle;
  late Ball ball;
  late GameState gameState;
  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier(3);

  @override
  Color backgroundColor() => const Color(0xFF000000); // Noir pur

  BreakoutGame({
    this.levelData,
    this.difficulty = GameDifficulty.arcade,
    this.onLevelCompleted,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await AudioManager.init();
    AudioManager.playMusic('bgm.wav');
    gameState = GameState();

    // Paddle
    paddle = Paddle(
      size: Vector2(100, 20),
      position: Vector2(size.x / 2, size.y - 50),
    );
    await add(paddle);

    // Ball
    _spawnBall();

    // Grid
    _generateGrid();
  }

  void _spawnBall() {
    ball = Ball(
      radius: 8,
      position: Vector2(size.x / 2, size.y - 80),
      baseVelocity: Vector2(250, -250), // Starting upwards
    );
    add(ball);
  }

  void _generateGrid() {
    children.whereType<Brick>().forEach((b) => b.removeFromParent());
    children.whereType<EffectZone>().forEach((z) => z.removeFromParent());

    final double padding = 2.0;
    final double topOffset = 50.0;
    
    if (levelData != null) {
      final grid = levelData!.grid;
      final int rows = grid.length;
      final int cols = grid[0].length;
      final double brickWidth = (size.x - (cols + 1) * padding) / cols;
      final double brickHeight = 20.0;

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          int type = grid[r][c];
          if (type == 0) continue;

          final pos = Vector2(padding + c * (brickWidth + padding), topOffset + r * (brickHeight + padding));
          final sz = Vector2(brickWidth, brickHeight);

          if (type == 10) {
            add(EffectZone(position: pos, size: sz));
            continue;
          }

          BrickColor color = BrickColor.yellow;
          int hp = 1;
          bool isIndestructible = false;
          bool isMoving = false;

          switch (type) {
            case 1: color = BrickColor.yellow; break;
            case 2: color = BrickColor.green; break;
            case 3: color = BrickColor.orange; break;
            case 4: color = BrickColor.red; break;
            case 5: color = BrickColor.green; hp = 2; break;
            case 6: color = BrickColor.red; hp = 3; break;
            case 7: color = BrickColor.yellow; isMoving = true; break;
            case 8: color = BrickColor.green; isMoving = true; break;
            case 9: isIndestructible = true; break;
            case 99: color = BrickColor.red; hp = 10; sz.scale(2); break; // Boss
          }

          add(Brick(position: pos, size: sz, colorType: color, hp: hp, isIndestructible: isIndestructible, isMoving: isMoving));
        }
      }
    } else {
      // Classic mode generation
      const int rows = 8;
      const int cols = 14;
      final double brickWidth = (size.x - (cols + 1) * padding) / cols;
      final double brickHeight = 20.0;
      final rowColors = [
        BrickColor.red, BrickColor.red,
        BrickColor.orange, BrickColor.orange,
        BrickColor.green, BrickColor.green,
        BrickColor.yellow, BrickColor.yellow,
      ];
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          add(Brick(
            position: Vector2(padding + c * (brickWidth + padding), topOffset + r * (brickHeight + padding)),
            size: Vector2(brickWidth, brickHeight),
            colorType: rowColors[r],
          ));
        }
      }
    }
  }

  void onBrickHit(Brick brick) {
    AudioManager.playSfx('hit_brick.wav');
    brick.hit();
    
    // Check for victory condition in campaign mode
    if (levelData != null) {
      bool noMoreBricks = children
          .whereType<Brick>()
          .where((b) => !b.isIndestructible && !b.isDestroyed)
          .isEmpty;
      if (noMoreBricks) {
        ball.removeFromParent(); // Stop ball
        AudioManager.playSfx('level_win.wav');
        if (onLevelCompleted != null) {
          int stars = gameState.lives == 3 ? 3 : (gameState.lives == 2 ? 2 : 1);
          onLevelCompleted!(gameState.score, stars);
        }
        return;
      }
    }

    bool nextScreen = gameState.onBrickDestroyed(brick.colorType);
    _updateUI();

    // Update ball speed based on mode
    if (levelData != null) {
      // In campaign, balance speed via world
      int world = levelData!.world;
      // World 1 = 1.0 multiplier cap initially, World 6 = fast
      double campaignMult = 1.0 + (world * 0.05); 
      // Soften speed multiplier in campaign
      ball.setSpeedMultiplier(gameState.speedMultiplier * campaignMult);
    } else {
      ball.setSpeedMultiplier(gameState.speedMultiplier);
    }

    if (nextScreen) {
      _generateGrid();
      // Keep ball active and speed as per requirement
    }
  }

  void onTopWallHit() {
    bool shouldShrink = gameState.onTopWallHit();
    if (shouldShrink) {
      if (levelData != null) {
        if (levelData!.world > 3) {
          paddle.shrink();
        }
      } else {
        paddle.shrink();
      }
    }
  }

  void onBottomWallHit() {
    bool isGameOver = gameState.onBallLost();
    _updateUI();
    ball.removeFromParent();

    if (!isGameOver) {
      AudioManager.playSfx('lose_life.wav');
      gameState.resetBallState();
      paddle.restore();
      _spawnBall();
    } else {
      AudioManager.playSfx('lose_life.wav'); 
      // Handle Game Over (e.g. Save high score, show Game Over text)
      final gameOverText = TextComponent(
        text: 'GAME OVER\nScore: ${gameState.score}',
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
      );
      add(gameOverText);
      // Let it sit there for the prototype. A proper restart button can be added later.
    }
  }

  @override
  void onRemove() {
    AudioManager.stopMusic();
    super.onRemove();
  }

  void _updateUI() {
    scoreNotifier.value = gameState.score;
    livesNotifier.value = gameState.lives;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    paddle.move(event.localDelta.x);
  }
}

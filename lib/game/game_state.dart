enum BrickColor { yellow, green, orange, red }

class GameState {
  int score = 0;
  int lives = 3;
  int currentScreen = 1;
  int screenBricksDestroyed = 0;

  // Per-ball states
  int ballBricksDestroyed = 0;
  int ballSpeedLevel = 0; // 0 (V1), 1 (V2), 2 (V3), 3 (V4)
  bool paddleShrunk = false;

  final int maxScreens = 2;
  final int totalBricksPerScreen = 112; // 14 * 8

  void reset() {
    score = 0;
    lives = 3;
    currentScreen = 1;
    screenBricksDestroyed = 0;
    resetBallState();
  }

  void resetBallState() {
    ballBricksDestroyed = 0;
    ballSpeedLevel = 0;
    paddleShrunk = false;
  }

  /// Returns true if a new screen should be generated.
  bool onBrickDestroyed(BrickColor color) {
    if (currentScreen > maxScreens) return false;

    // Score
    switch (color) {
      case BrickColor.yellow:
        score += 1;
        break;
      case BrickColor.green:
        score += 3;
        break;
      case BrickColor.orange:
        score += 5;
        ballSpeedLevel = _max(ballSpeedLevel, 3);
        break;
      case BrickColor.red:
        score += 7;
        ballSpeedLevel = _max(ballSpeedLevel, 3);
        break;
    }

    ballBricksDestroyed++;
    screenBricksDestroyed++;

    if (ballBricksDestroyed == 4) {
      ballSpeedLevel = _max(ballSpeedLevel, 1);
    } else if (ballBricksDestroyed == 12) {
      ballSpeedLevel = _max(ballSpeedLevel, 2);
    }

    if (screenBricksDestroyed >= totalBricksPerScreen) {
      currentScreen++;
      if (currentScreen <= maxScreens) {
        screenBricksDestroyed = 0;
        return true; // Generate next screen
      }
    }
    return false;
  }

  int _max(int a, int b) => a > b ? a : b;

  double get speedMultiplier {
    switch (ballSpeedLevel) {
      case 0: return 1.0;
      case 1: return 1.15;
      case 2: return 1.30;
      case 3: return 1.50;
      default: return 1.0;
    }
  }

  /// Returns true if the paddle should shrink
  bool onTopWallHit() {
    if (!paddleShrunk) {
      paddleShrunk = true;
      return true;
    }
    return false;
  }

  /// Returns true if game is over
  bool onBallLost() {
    lives--;
    return lives <= 0;
  }
}

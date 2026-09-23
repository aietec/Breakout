enum BrickColor { yellow, green, orange, red }

class GameState {
  int score = 0;
  int lives = 3;
  int currentScreen = 1;
  int screenBricksDestroyed = 0;

  // Global states for the game
  int speedLevel = 0; // 0 (V1), 1 (V2), 2 (V3), 3 (V4)
  bool paddleShrunk = false;
  bool hasHitRed = false;
  
  // Speed triggers
  bool hit4Bricks = false;
  bool hit12Bricks = false;
  bool hitOrange = false;
  bool hitRedSpeed = false;
  int totalBricksHit = 0;

  final int maxScreens = 2;
  final int totalBricksPerScreen = 112; // 14 * 8

  void reset() {
    score = 0;
    lives = 3;
    currentScreen = 1;
    screenBricksDestroyed = 0;
    speedLevel = 0;
    paddleShrunk = false;
    hasHitRed = false;
    hit4Bricks = false;
    hit12Bricks = false;
    hitOrange = false;
    hitRedSpeed = false;
    totalBricksHit = 0;
  }

  void resetBallState() {
    // In classic rules (as per prompt), speed triggers and paddle shrink persist over the entire game.
    // So we don't reset paddleShrunk or speedLevel here.
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
        if (!hitOrange) {
          hitOrange = true;
          speedLevel = _max(speedLevel, 3);
        }
        break;
      case BrickColor.red:
        score += 7;
        hasHitRed = true;
        if (!hitRedSpeed) {
          hitRedSpeed = true;
          speedLevel = _max(speedLevel, 3);
        }
        break;
    }

    screenBricksDestroyed++;
    totalBricksHit++;

    if (totalBricksHit == 4 && !hit4Bricks) {
      hit4Bricks = true;
      speedLevel = _max(speedLevel, 1);
    } 
    if (totalBricksHit == 12 && !hit12Bricks) {
      hit12Bricks = true;
      speedLevel = _max(speedLevel, 2);
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
    switch (speedLevel) {
      case 0: return 1.0;
      case 1: return 1.15;
      case 2: return 1.30;
      case 3: return 1.50;
      default: return 1.0;
    }
  }

  /// Returns true if the paddle should shrink
  bool onTopWallHit() {
    if (hasHitRed && !paddleShrunk) {
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

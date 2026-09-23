import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../game_state.dart';
import '../breakout_game.dart';

class Brick extends PositionComponent with CollisionCallbacks, HasGameRef<BreakoutGame> {
  final BrickColor colorType;
  late final Paint _paint;
  bool isDestroyed = false;
  int hp;
  bool isIndestructible;
  bool isMoving;
  
  Vector2 velocity = Vector2.zero();
  double boundaryLeft = 0;
  double boundaryRight = 0;

  Brick({
    required Vector2 position,
    required Vector2 size,
    required this.colorType,
    this.hp = 1,
    this.isIndestructible = false,
    this.isMoving = false,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        ) {
    _paint = Paint()..color = _getColorForType(colorType);
    if (isMoving) {
      velocity = Vector2(100, 0); // Speed of 100 px/s
    }
  }

  Color _getColorForType(BrickColor type) {
    switch (type) {
      case BrickColor.yellow:
        return Colors.yellow;
      case BrickColor.green:
        return Colors.green;
      case BrickColor.orange:
        return Colors.orange;
      case BrickColor.red:
        return Colors.red;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    boundaryLeft = position.x - 50;
    boundaryRight = position.x + size.x + 50;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving && !isDestroyed) {
      position += velocity * dt;
      if (position.x < boundaryLeft) {
        position.x = boundaryLeft;
        velocity.x = -velocity.x;
      } else if (position.x + size.x > boundaryRight) {
        position.x = boundaryRight - size.x;
        velocity.x = -velocity.x;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isDestroyed) {
      if (isIndestructible) {
        _paint.color = Colors.grey;
      } else if (hp > 1) {
        _paint.color = _paint.color.withValues(alpha: 0.5 + (0.5 * hp / 3).clamp(0.0, 1.0));
      }
      canvas.drawRect(size.toRect(), _paint);
      
      canvas.drawRect(
        size.toRect(),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void hit() {
    if (isIndestructible) {
      // Play metal clank sound
      return;
    }
    
    hp--;
    if (hp <= 0) {
      isDestroyed = true;
      removeFromParent();
    }
  }
}

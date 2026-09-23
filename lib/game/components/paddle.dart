import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';

class Paddle extends PositionComponent with CollisionCallbacks {
  final Paint _paint = Paint()..color = Colors.blue;
  bool _isShrunk = false;
  late double _originalWidth;

  Paddle({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        ) {
    _originalWidth = size.x;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  void move(double deltaX) {
    position.x += deltaX;
    
    final halfWidth = size.x / 2;
    if (position.x - halfWidth < 0) {
      position.x = halfWidth;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final parentSize = (parent as FlameGame).size;
    final halfWidth = size.x / 2;
    if (position.x + halfWidth > parentSize.x) {
      position.x = parentSize.x - halfWidth;
    }
  }

  void shrink() {
    if (!_isShrunk) {
      _isShrunk = true;
      size.x = _originalWidth / 2;
    }
  }

  void restore() {
    if (_isShrunk) {
      _isShrunk = false;
      size.x = _originalWidth;
    }
  }
}

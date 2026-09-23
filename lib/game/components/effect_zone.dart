import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class EffectZone extends PositionComponent {
  late final Paint _paint;

  EffectZone({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        ) {
    _paint = Paint()
      ..color = Colors.purple.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox(isSolid: false));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}

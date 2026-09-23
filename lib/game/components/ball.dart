import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../audio/audio_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'paddle.dart';
import 'brick.dart';
import 'effect_zone.dart';
import '../breakout_game.dart';

class Ball extends PositionComponent with CollisionCallbacks, HasGameRef<BreakoutGame> {
  final Paint _paint = Paint()..color = Colors.white;
  Vector2 baseVelocity;
  Vector2 velocity;
  final double radius;
  double speedMultiplier = 1.0;

  Ball({
    required Vector2 position,
    required this.radius,
    required this.baseVelocity,
  })  : velocity = baseVelocity.clone(),
        super(
          position: position,
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
  }

  final double maxSpeed = 600.0; // Plafond de sécurité

  void setSpeedMultiplier(double mult) {
    speedMultiplier = mult;
    // Normalize and scale current velocity to new magnitude
    double newSpeed = baseVelocity.length * speedMultiplier;
    // Safety cap
    if (newSpeed > maxSpeed) {
      newSpeed = maxSpeed;
    }
    velocity = velocity.normalized() * newSpeed;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(radius, radius), radius, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Bounce on screen edges
    if (position.x - radius < 0) {
      position.x = radius;
      velocity.x = -velocity.x;
      AudioManager.playSfx('hit_wall.wav');
    } else if (position.x + radius > gameRef.size.x) {
      position.x = gameRef.size.x - radius;
      velocity.x = -velocity.x;
      AudioManager.playSfx('hit_wall.wav');
    }

    if (position.y - radius < 0) {
      position.y = radius;
      velocity.y = -velocity.y;
      AudioManager.playSfx('hit_wall.wav');
      gameRef.onTopWallHit();
    } else if (position.y + radius > gameRef.size.y) {
      // Bottom wall hit
      gameRef.onBottomWallHit();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Paddle) {
      AudioManager.playSfx('hit_paddle.wav');
      
      final paddleCenter = other.position.x;
      final ballCenter = position.x;
      final hitFactor = (ballCenter - paddleCenter) / (other.size.x / 2);
      final clampedFactor = hitFactor.clamp(-1.0, 1.0);
      final absFactor = clampedFactor.abs();
      
      double angle; // relative to negative Y axis
      if (absFactor < 0.25) {
        angle = 15.0; // Zone centrale
      } else if (absFactor < 0.5) {
        angle = 30.0; // Zone intermédiaire
      } else if (absFactor < 0.75) {
        angle = 45.0; // Zone extérieure
      } else {
        angle = 60.0; // Extrémités
      }
      
      final rad = angle * math.pi / 180.0;
      // clampedFactor.sign gives -1 for left, 1 for right, 0 for center
      // If 0, we can default to a tiny horizontal speed or keep it 0.
      final sign = clampedFactor < 0 ? -1.0 : 1.0;
      final directionX = math.sin(rad) * sign;
      final directionY = -math.cos(rad);
      
      double currentSpeed = baseVelocity.length * speedMultiplier;
      if (currentSpeed > maxSpeed) {
        currentSpeed = maxSpeed;
      }
      velocity = Vector2(directionX, directionY).normalized() * currentSpeed;

    } else if (other is EffectZone) {
      // Speed up ball slightly in zone
      velocity = velocity * 1.05;
      
      // Prevent infinite speed
      if (velocity.length > 800) {
        velocity = velocity.normalized() * 800;
      }
    } else if (other is Brick) {
      if (!other.isDestroyed) {
        final p = intersectionPoints.first;
        final dx = (p.x - position.x).abs();
        final dy = (p.y - position.y).abs();
        
        if (dx > dy) {
          velocity.x = -velocity.x;
        } else {
          velocity.y = -velocity.y;
        }
        
        gameRef.onBrickHit(other);
      }
    }
  }
}

import 'dart:convert';
import 'level_data.dart';

class GameSnapshot {
  final LevelData level;
  final int score;
  final int lives;
  final int bricksDestroyed;
  final double paddleX;
  final double ballX;
  final double ballY;
  final double ballVX;
  final double ballVY;

  GameSnapshot({
    required this.level,
    required this.score,
    required this.lives,
    required this.bricksDestroyed,
    required this.paddleX,
    required this.ballX,
    required this.ballY,
    required this.ballVX,
    required this.ballVY,
  });

  factory GameSnapshot.fromJson(Map<String, dynamic> json) {
    return GameSnapshot(
      level: LevelData.fromJson(json['level']),
      score: json['score'],
      lives: json['lives'],
      bricksDestroyed: json['bricksDestroyed'],
      paddleX: (json['paddleX'] as num).toDouble(),
      ballX: (json['ballX'] as num).toDouble(),
      ballY: (json['ballY'] as num).toDouble(),
      ballVX: (json['ballVX'] as num).toDouble(),
      ballVY: (json['ballVY'] as num).toDouble(),
    );
  }

  factory GameSnapshot.fromJsonString(String jsonString) {
    return GameSnapshot.fromJson(jsonDecode(jsonString));
  }

  Map<String, dynamic> toJson() => {
    'level': level.toJson(),
    'score': score,
    'lives': lives,
    'bricksDestroyed': bricksDestroyed,
    'paddleX': paddleX,
    'ballX': ballX,
    'ballY': ballY,
    'ballVX': ballVX,
    'ballVY': ballVY,
  };

  String toJsonString() => jsonEncode(toJson());
}

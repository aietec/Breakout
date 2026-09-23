import 'dart:convert';

class LevelObjectives {
  final int timeTarget;
  final int livesTarget;

  LevelObjectives({required this.timeTarget, required this.livesTarget});

  factory LevelObjectives.fromJson(Map<String, dynamic> json) {
    return LevelObjectives(
      timeTarget: json['timeTarget'] ?? 120,
      livesTarget: json['livesTarget'] ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {
    'timeTarget': timeTarget,
    'livesTarget': livesTarget,
  };
}

class LevelData {
  final String id;
  final int world;
  final int level;
  final String name;
  final double initialSpeed;
  final LevelObjectives objectives;
  final List<List<int>> grid;

  LevelData({
    required this.id,
    required this.world,
    required this.level,
    required this.name,
    required this.initialSpeed,
    required this.objectives,
    required this.grid,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    var gridList = json['grid'] as List;
    List<List<int>> parsedGrid = gridList.map((row) => List<int>.from(row)).toList();

    return LevelData(
      id: json['id'],
      world: json['world'],
      level: json['level'],
      name: json['name'],
      initialSpeed: (json['initialSpeed'] as num).toDouble(),
      objectives: LevelObjectives.fromJson(json['objectives']),
      grid: parsedGrid,
    );
  }

  factory LevelData.fromJsonString(String jsonString) {
    return LevelData.fromJson(jsonDecode(jsonString));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'world': world,
    'level': level,
    'name': name,
    'initialSpeed': initialSpeed,
    'objectives': objectives.toJson(),
    'grid': grid,
  };
}

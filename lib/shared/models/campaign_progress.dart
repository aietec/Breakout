import 'dart:convert';

class CampaignProgress {
  final int highestWorldUnlocked;
  final int highestLevelUnlocked;
  final Map<String, int> starsPerLevel; // e.g. "1-1": 3
  final Map<String, int> bestScorePerLevel;

  CampaignProgress({
    this.highestWorldUnlocked = 1,
    this.highestLevelUnlocked = 1,
    Map<String, int>? starsPerLevel,
    Map<String, int>? bestScorePerLevel,
  })  : starsPerLevel = starsPerLevel ?? {},
        bestScorePerLevel = bestScorePerLevel ?? {};

  factory CampaignProgress.fromJson(Map<String, dynamic> json) {
    return CampaignProgress(
      highestWorldUnlocked: json['highestWorldUnlocked'] ?? 1,
      highestLevelUnlocked: json['highestLevelUnlocked'] ?? 1,
      starsPerLevel: Map<String, int>.from(json['starsPerLevel'] ?? {}),
      bestScorePerLevel: Map<String, int>.from(json['bestScorePerLevel'] ?? {}),
    );
  }

  factory CampaignProgress.fromJsonString(String jsonString) {
    return CampaignProgress.fromJson(jsonDecode(jsonString));
  }

  Map<String, dynamic> toJson() => {
    'highestWorldUnlocked': highestWorldUnlocked,
    'highestLevelUnlocked': highestLevelUnlocked,
    'starsPerLevel': starsPerLevel,
    'bestScorePerLevel': bestScorePerLevel,
  };

  String toJsonString() => jsonEncode(toJson());

  bool isLevelUnlocked(int world, int level) {
    if (world < highestWorldUnlocked) return true;
    if (world == highestWorldUnlocked && level <= highestLevelUnlocked) return true;
    return false;
  }
}

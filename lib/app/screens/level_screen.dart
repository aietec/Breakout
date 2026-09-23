import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../campaign/campaign_manager.dart';
import '../../game/breakout_game.dart';
import '../../shared/models/level_data.dart';
import 'campaign_menu.dart'; // for GameDifficulty enum

class LevelScreen extends StatefulWidget {
  final int world;
  final int level;
  final GameDifficulty difficulty;

  const LevelScreen({
    super.key,
    required this.world,
    required this.level,
    required this.difficulty,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final CampaignManager _manager = CampaignManager();
  LevelData? _levelData;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    try {
      final data = await _manager.loadLevel(widget.world, widget.level);
      setState(() {
        _levelData = data;
      });
    } catch (e, stackTrace) {
      stderr.writeln('=== ERREUR CHARGEMENT NIVEAU ===');
      stderr.writeln(e);
      stderr.writeln(stackTrace);
      stderr.writeln('================================');
      
      debugPrint("Erreur _loadLevel: $e\n$stackTrace");
      setState(() {
        _errorMessage = "Erreur de chargement du niveau : ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    if (_levelData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final game = BreakoutGame(
      levelData: _levelData,
      difficulty: widget.difficulty,
      onLevelCompleted: (score, stars) async {
        await _manager.updateLevelProgress(
          world: widget.world,
          level: widget.level,
          levelId: _levelData!.id,
          score: score,
          stars: stars,
        );
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Victoire !'),
              content: Text('Score: $score\nÉtoiles: $stars'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close level screen
                  },
                  child: const Text('Menu'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelScreen(
                          world: widget.world,
                          level: widget.level,
                          difficulty: widget.difficulty,
                        ),
                      ),
                    );
                  },
                  child: const Text('Rejouer'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    int nextWorld = widget.world;
                    int nextLevel = widget.level + 1;
                    if (nextLevel > 12) {
                      nextLevel = 1;
                      nextWorld++;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelScreen(
                          world: nextWorld,
                          level: nextLevel,
                          difficulty: widget.difficulty,
                        ),
                      ),
                    );
                  },
                  child: const Text('Niveau suivant'),
                ),
              ],
            ),
          );
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GameWidget(game: game),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: game.scoreNotifier,
                      builder: (context, score, _) {
                        return Text('Score: $score', style: const TextStyle(color: Colors.white, fontSize: 18));
                      },
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: game.livesNotifier,
                      builder: (context, lives, _) {
                        return Text('Vies: $lives', style: const TextStyle(color: Colors.white, fontSize: 18));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

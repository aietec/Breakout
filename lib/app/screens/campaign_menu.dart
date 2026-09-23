import 'package:flutter/material.dart';
import '../../campaign/campaign_manager.dart';
import '../../shared/models/campaign_progress.dart';
import 'level_screen.dart';

enum GameDifficulty { detente, arcade, expert }

class CampaignMenu extends StatefulWidget {
  const CampaignMenu({super.key});

  @override
  State<CampaignMenu> createState() => _CampaignMenuState();
}

class _CampaignMenuState extends State<CampaignMenu> {
  final CampaignManager _manager = CampaignManager();
  CampaignProgress? _progress;
  GameDifficulty _selectedDifficulty = GameDifficulty.arcade;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final p = await _manager.loadProgress();
      setState(() {
        _progress = p;
      });
    } catch (e, stackTrace) {
      debugPrint("Erreur _loadProgress: $e\n$stackTrace");
      setState(() {
        _errorMessage = "Erreur de chargement de la campagne : ${e.toString()}";
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
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                  _loadProgress();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Campagne - Monde 1')),
      body: Column(
        children: [
          _buildDifficultySelector(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final level = index + 1;
                final isUnlocked = _progress!.isLevelUnlocked(1, level);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUnlocked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: isUnlocked ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelScreen(
                          world: 1,
                          level: level,
                          difficulty: _selectedDifficulty,
                        ),
                      ),
                    ).then((_) => _loadProgress());
                  } : null,
                  child: Text('Niv \$level'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SegmentedButton<GameDifficulty>(
        segments: const [
          ButtonSegment(value: GameDifficulty.detente, label: Text('Détente')),
          ButtonSegment(value: GameDifficulty.arcade, label: Text('Arcade')),
          ButtonSegment(value: GameDifficulty.expert, label: Text('Expert')),
        ],
        selected: {_selectedDifficulty},
        onSelectionChanged: (Set<GameDifficulty> newSelection) {
          setState(() {
            _selectedDifficulty = newSelection.first;
          });
        },
      ),
    );
  }
}

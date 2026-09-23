import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'game/breakout_game.dart';
import 'app/screens/campaign_menu.dart';
import 'app/screens/settings_screen.dart';
import 'settings/settings_manager.dart';

final settingsManager = SettingsManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settingsManager.loadSettings();
  runApp(BreakoutApp(settings: settingsManager));
}

class BreakoutApp extends StatefulWidget {
  final SettingsManager settings;
  const BreakoutApp({super.key, required this.settings});

  @override
  State<BreakoutApp> createState() => _BreakoutAppState();
}

class _BreakoutAppState extends State<BreakoutApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Flame pauses automatically, but we can hook in save snapshots here if needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Breakout',
          locale: widget.settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
          ),
          home: const MainMenu(),
        );
      }
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(loc.appTitle, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
              },
              child: Text(loc.modeClassic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CampaignMenu()));
              },
              child: Text(loc.modeCampaign),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(settingsManager: settingsManager)));
              },
            )
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BreakoutGame(); // Runs classic mode by default
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

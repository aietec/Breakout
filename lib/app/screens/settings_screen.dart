import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../settings/settings_manager.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsManager settingsManager;

  const SettingsScreen({super.key, required this.settingsManager});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListenableBuilder(
        listenable: settingsManager,
        builder: (context, _) {
          return ListView(
            children: [
              ListTile(
                title: Text(loc.language),
                trailing: DropdownButton<String>(
                  value: settingsManager.locale?.languageCode ?? 'en',
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    // ... other languages
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      settingsManager.setLocale(Locale(val));
                    }
                  },
                ),
              ),
              SwitchListTile(
                title: Text(loc.highContrast),
                value: settingsManager.highContrast,
                onChanged: settingsManager.setHighContrast,
              ),
              SwitchListTile(
                title: Text(loc.vibration),
                value: settingsManager.vibration,
                onChanged: settingsManager.setVibration,
              ),
            ],
          );
        },
      ),
    );
  }
}

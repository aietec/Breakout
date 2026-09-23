import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:breakout/shared/models/level_data.dart';

void main() {
  group('Levels Integrity Test', () {
    test('All 72 levels should exist and parse correctly', () {
      final dir = Directory('assets/levels');
      expect(dir.existsSync(), true, reason: 'assets/levels directory missing');

      int validCount = 0;

      for (int w = 1; w <= 6; w++) {
        for (int l = 1; l <= 12; l++) {
          final file = File('${dir.path}/level_${w}_$l.json');
          expect(file.existsSync(), true, reason: 'Missing ${file.path}');

          final content = file.readAsStringSync();
          try {
            final levelData = LevelData.fromJsonString(content);
            expect(levelData.world, w);
            expect(levelData.level, l);
            expect(levelData.grid.isNotEmpty, true);
            validCount++;
          } catch (e) {
            fail('Failed to parse ${file.path}: $e');
          }
        }
      }

      expect(validCount, 72, reason: 'Expected exactly 72 valid levels.');
    });
  });
}

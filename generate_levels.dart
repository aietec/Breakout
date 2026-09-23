import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('assets/levels');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // Generate 72 levels for 6 Worlds
  for (int w = 1; w <= 6; w++) {
    for (int l = 1; l <= 12; l++) {
      int globalLevel = (w - 1) * 12 + l;
      final int rows = 4 + (l ~/ 2); // 4 to 9 rows
      final int cols = 14;
      final List<List<int>> grid = [];

      for (int r = 0; r < rows; r++) {
        List<int> row = [];
        for (int c = 0; c < cols; c++) {
          int type = 0;
          
          if (w == 1) { // World 1: Basics
            type = (r % 4) + 1; // 1 to 4
          } else if (w == 2) { // World 2: Multi-HP
            type = (r % 2 == 0) ? 5 : ((r % 4) + 1); // 5 is 2HP
            if (l > 6 && r == 0) type = 6; // 6 is 3HP
          } else if (w == 3) { // World 3: Movement
            type = (r % 2 != 0) ? 7 : 2; // 7 is Moving Yellow
            if (l > 6 && r == 2) type = 8; // 8 is Moving Green
          } else if (w == 4) { // World 4: Perturbations
            type = (r % 3 == 0 && c % 3 == 0) ? 9 : 3; // 9 is Indestructible
            if (l > 6 && r == 1 && c == 7) type = 10; // 10 is Accel/Deviation zone
          } else if (w == 5) { // World 5: Mastery
            int rand = (r * c + l) % 10;
            type = (rand == 0) ? 9 : (rand < 3) ? 5 : (rand == 4) ? 7 : (r % 4) + 1;
          } else if (w == 6) { // World 6: Bosses
            if (l % 4 == 0 && r == 0 && c == cols ~/ 2) {
              type = 99; // Boss
            } else {
              int rand = (r * c + l) % 12;
              type = (rand == 0) ? 9 : (rand == 1) ? 10 : (rand < 4) ? 6 : (rand < 6) ? 8 : (r % 4) + 1;
            }
          }

          // Make some holes to teach precision
          if (l > 2 && c % (l + 1) == 0 && type < 9) {
            type = 0;
          }
          row.add(type);
        }
        grid.add(row);
      }

      final levelData = {
        "id": "$w-$l",
        "world": w,
        "level": l,
        "name": "Monde $w - Niveau $l",
        "initialSpeed": 250.0 + (globalLevel * 5),
        "objectives": {
          "timeTarget": 120 + (l * 10),
          "livesTarget": 2
        },
        "grid": grid
      };

      final file = File('${dir.path}/level_${w}_$l.json');
      file.writeAsStringSync(jsonEncode(levelData));
    }
  }
  print('Generated 72 levels.');
}

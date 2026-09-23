import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakout/scores/sync_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncManager Queue', () {
    late SyncManager manager;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      // Null Firestore means it won't actually sync to network, just tests the queue logic
      manager = SyncManager(firestore: null, auth: null); 
    });

    test('Score above 896 in classic is rejected locally', () async {
      await manager.submitScore(900, 'classic');
      final queue = await manager.getPendingScores();
      expect(queue.isEmpty, true);
    });

    test('Valid classic score is added to local queue', () async {
      await manager.submitScore(448, 'classic');
      final queue = await manager.getPendingScores();
      expect(queue.length, 1);
      expect(queue.first.score, 448);
      expect(queue.first.status, ScoreStatus.pending);
    });

    test('Campaign score is added to local queue', () async {
      await manager.submitScore(1200, 'campaign_1-1');
      final queue = await manager.getPendingScores();
      expect(queue.length, 1);
      expect(queue.first.score, 1200);
      expect(queue.first.mode, 'campaign_1-1');
    });

    test('Multiple scores are queued idempotently', () async {
      await manager.submitScore(100, 'classic');
      await manager.submitScore(200, 'classic');
      
      final queue = await manager.getPendingScores();
      expect(queue.length, 2);
      expect(queue[0].id, isNot(equals(queue[1].id)));
    });
  });
}

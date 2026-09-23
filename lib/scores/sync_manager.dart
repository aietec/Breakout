import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum ScoreStatus { local, pending, validated, rejected }

class ScoreRecord {
  final String id;
  final int score;
  final String mode; // 'classic' or 'campaign_1-1'
  ScoreStatus status;
  final int timestamp;

  ScoreRecord({
    required this.id,
    required this.score,
    required this.mode,
    this.status = ScoreStatus.local,
    required this.timestamp,
  });

  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      id: json['id'],
      score: json['score'],
      mode: json['mode'],
      status: ScoreStatus.values.firstWhere((e) => e.toString() == json['status']),
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'score': score,
    'mode': mode,
    'status': status.toString(),
    'timestamp': timestamp,
  };
}

class SyncManager {
  static const String _queueKey = 'score_sync_queue';
  final FirebaseFirestore? _firestore; // Injectable for tests or null-safe
  final FirebaseAuth? _auth;

  SyncManager({this._firestore, this._auth});

  Future<void> submitScore(int score, String mode) async {
    // 1. Validate constraints locally first
    if (mode == 'classic' && score > 896) {
      // Automatic rejection of impossible score
      return; 
    }

    final record = ScoreRecord(
      id: const Uuid().v4(),
      score: score,
      mode: mode,
      status: ScoreStatus.pending,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await _addToQueue(record);
    await syncQueue();
  }

  Future<void> _addToQueue(ScoreRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);
    queue.add(record);
    await prefs.setString(_queueKey, jsonEncode(queue.map((e) => e.toJson()).toList()));
  }

  List<ScoreRecord> _getQueue(SharedPreferences prefs) {
    final String? data = prefs.getString(_queueKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => ScoreRecord.fromJson(e)).toList();
  }

  Future<void> syncQueue() async {
    if (_firestore == null) return; // Only mock/local in this env if null
    
    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);
    
    if (queue.isEmpty) return;
    
    final user = _auth?.currentUser;
    if (user == null) {
      try {
        await _auth?.signInAnonymously();
      } catch (e) {
        return; // Network error likely, keep in queue
      }
    }

    List<ScoreRecord> remainingQueue = [];

    for (var record in queue) {
      if (record.status == ScoreStatus.pending || record.status == ScoreStatus.local) {
        try {
          // Idempotent write using the record ID as document ID
          await _firestore.collection('scores').doc(record.id).set({
            'userId': _auth?.currentUser?.uid ?? 'anonymous',
            'score': record.score,
            'mode': record.mode,
            'timestamp': record.timestamp,
            'clientStatus': 'submitted'
          });
          // Note: Server-side Cloud Function or Rules should validate this
          // We mark it as validated locally for now (optimistic UI) or remove from queue
          // Actually, if it succeeded, we just remove it from the pending queue.
        } catch (e) {
          // Keep in queue for next sync
          remainingQueue.add(record);
        }
      }
    }

    await prefs.setString(_queueKey, jsonEncode(remainingQueue.map((e) => e.toJson()).toList()));
  }

  Future<List<ScoreRecord>> getPendingScores() async {
    final prefs = await SharedPreferences.getInstance();
    return _getQueue(prefs);
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/barcode_model.dart';

class BarcodeDatabase {
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'barcodes.db');
    return openDatabase(
      path,
      version: 4,
      onCreate: _create,
      onUpgrade: _upgrade,
    );
  }

  Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE barcodes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        event_name TEXT NOT NULL,
        holder_name TEXT NOT NULL DEFAULT '',
        ticket_type TEXT NOT NULL DEFAULT '',
        is_used INTEGER NOT NULL DEFAULT 0,
        used_at INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');
    await _seed(db);
  }

  Future<void> _upgrade(Database db, int old, int version) async {
    await db.execute('DROP TABLE IF EXISTS barcodes');
    await _create(db, version);
  }

  Future<void> _seed(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final data = [
      ('TKT-001', 'Music Festival 2025', 'Alice Johnson', 'VIP Pass', false),
      ('TKT-002', 'Music Festival 2025', 'Alice Johnson', 'VIP Pass', false),
      ('TKT-005', 'Tech Conference', 'Eve Martin', 'Speaker Pass', false),
      ('TKT-006', 'Tech Conference', 'Frank Wilson', 'Standard', true),
      ('TKT-007', 'Tech Conference', 'Grace Kim', 'Workshop Pass', false),
      ('TKT-008', 'Art Exhibition', 'Henry Brown', 'Premium Ticket', false),
      (
        'TKT-009',
        'Music Festival 2025',
        'Ivy Chen',
        'General Admission',
        false,
      ),
      ('TKT-012', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
      ('TKT-013', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
      ('TKT-014', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
      ('TKT-015', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
      ('TKT-016', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
      ('TKT-017', 'Tech Conference', 'Leo Martinez', 'Speaker Pass', false),
    ];

    for (final (code, event, name, type, used) in data) {
      await db.insert('barcodes', {
        'code': code,
        'event_name': event,
        'holder_name': name,
        'ticket_type': type,
        'is_used': used ? 1 : 0,
        'used_at': used ? now : null,
        'created_at': now,
      });
    }
  }

  Future<BarcodeModel?> findByCode(String code) async {
    final db = await database;
    final maps = await db.query(
      'barcodes',
      where: 'code = ?',
      whereArgs: [code],
    );
    return maps.isEmpty ? null : BarcodeModel.fromMap(maps.first);
  }

  Future<void> markAsUsed(int id) async {
    final db = await database;
    await db.update(
      'barcodes',
      {'is_used': 1, 'used_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BarcodeModel>> getAllBarcodes() async {
    final db = await database;
    final maps = await db.query('barcodes', orderBy: 'created_at DESC');
    return maps.map(BarcodeModel.fromMap).toList();
  }

  Future<Map<String, int>> getBarcodeStats() async {
    final db = await database;
    final all = await db.query('barcodes');
    final total = all.length;
    final used = all.where((m) => (m['is_used'] as int) == 1).length;
    final now = DateTime.now();
    final todayScanned = all.where((m) {
      if ((m['is_used'] as int) != 1 || m['used_at'] == null) return false;
      final dt = DateTime.fromMillisecondsSinceEpoch(m['used_at'] as int);
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    }).length;

    return {
      'total': total,
      'used': used,
      'available': total - used,
      'todayScanned': todayScanned,
    };
  }
}

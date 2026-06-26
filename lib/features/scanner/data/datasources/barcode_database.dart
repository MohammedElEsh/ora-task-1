import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../models/barcode_model.dart';

class BarcodeDatabase {
  static const _tag = 'BarcodeDatabase';
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    LoggerService.d('Initializing database', tag: _tag);
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barcodes.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        LoggerService.i('Creating barcodes table (version $version)', tag: _tag);
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
        await _seedDemoData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        LoggerService.w('Upgrading database from v$oldVersion to v$newVersion', tag: _tag);
        await db.execute('DROP TABLE IF EXISTS barcodes');
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
        await _seedDemoData(db);
      },
    );
  }

  Future<void> _seedDemoData(Database db) async {
    LoggerService.d('Seeding demo data', tag: _tag);
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.insert('barcodes', {
      'code': 'TKT-001',
      'event_name': 'Music Festival 2025',
      'holder_name': 'Alice Johnson',
      'ticket_type': 'VIP Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-002',
      'event_name': 'Music Festival 2025',
      'holder_name': 'Alice Johnson',
      'ticket_type': 'VIP Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-005',
      'event_name': 'Tech Conference',
      'holder_name': 'Eve Martin',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-006',
      'event_name': 'Tech Conference',
      'holder_name': 'Frank Wilson',
      'ticket_type': 'Standard',
      'is_used': 1,
      'used_at': now,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-007',
      'event_name': 'Tech Conference',
      'holder_name': 'Grace Kim',
      'ticket_type': 'Workshop Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-008',
      'event_name': 'Art Exhibition',
      'holder_name': 'Henry Brown',
      'ticket_type': 'Premium Ticket',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-009',
      'event_name': 'Music Festival 2025',
      'holder_name': 'Ivy Chen',
      'ticket_type': 'General Admission',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-012',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-013',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-014',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-015',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-016',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });

    await db.insert('barcodes', {
      'code': 'TKT-017',
      'event_name': 'Tech Conference',
      'holder_name': 'Leo Martinez',
      'ticket_type': 'Speaker Pass',
      'is_used': 0,
      'created_at': now,
    });
  }

  Future<BarcodeModel?> findByCode(String code) async {
    LoggerService.d('Finding barcode by code: $code', tag: _tag);
    final db = await database;
    final maps = await db.query(
      'barcodes',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isEmpty) {
      LoggerService.d('Barcode not found: $code', tag: _tag);
      return null;
    }
    LoggerService.d('Barcode found: $code', tag: _tag);
    return BarcodeModel.fromMap(maps.first);
  }

  Future<void> markAsUsed(int id) async {
    LoggerService.i('Marking barcode as used: id=$id', tag: _tag);
    final db = await database;
    await db.update(
      'barcodes',
      {'is_used': 1, 'used_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BarcodeModel>> getAllBarcodes() async {
    LoggerService.d('Getting all barcodes', tag: _tag);
    final db = await database;
    final maps = await db.query('barcodes', orderBy: 'created_at DESC');
    LoggerService.d('Found ${maps.length} barcodes', tag: _tag);
    return maps.map((map) => BarcodeModel.fromMap(map)).toList();
  }

  Future<Map<String, int>> getBarcodeStats() async {
    LoggerService.d('Getting barcode stats', tag: _tag);
    final db = await database;
    final all = await db.query('barcodes');
    final total = all.length;
    final used = all.where((m) => (m['is_used'] as int) == 1).length;
    final available = total - used;

    final today = DateTime.now();
    final todayScanned = all.where((m) {
      if ((m['is_used'] as int) != 1 || m['used_at'] == null) return false;
      final usedAt = DateTime.fromMillisecondsSinceEpoch(m['used_at'] as int);
      return usedAt.year == today.year &&
          usedAt.month == today.month &&
          usedAt.day == today.day;
    }).length;

    LoggerService.d('Stats: total=$total, used=$used, available=$available, today=$todayScanned', tag: _tag);
    return {
      'total': total,
      'used': used,
      'available': available,
      'todayScanned': todayScanned,
    };
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/barcode_model.dart';

class BarcodeDatabase {
  Database? _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barcodes.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
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

  Future<void> resetAndSeed() async {
    final db = await database;
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
  }

  Future<void> _seedDemoData(Database db) async {
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

  Future<void> insertBarcode(BarcodeModel barcode) async {
    final db = await database;
    await db.insert(
      'barcodes',
      barcode.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBarcodes(List<BarcodeModel> barcodes) async {
    final db = await database;
    final batch = db.batch();
    for (final barcode in barcodes) {
      batch.insert(
        'barcodes',
        barcode.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<BarcodeModel?> findByCode(String code) async {
    final db = await database;
    final maps = await db.query(
      'barcodes',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isEmpty) return null;
    return BarcodeModel.fromMap(maps.first);
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
    return maps.map((map) => BarcodeModel.fromMap(map)).toList();
  }

  Future<void> deleteBarcode(int id) async {
    final db = await database;
    await db.delete('barcodes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('barcodes');
  }

  Future<void> seedDemoData() async {
    await resetAndSeed();
  }
}

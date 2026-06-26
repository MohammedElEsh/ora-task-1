import '../../../../core/services/logger/logger_service.dart';
import '../datasources/barcode_database.dart';
import '../models/barcode_model.dart';
import 'barcode_repository.dart';

class BarcodeRepositoryImpl implements BarcodeRepository {
  static const _tag = 'BarcodeRepository';
  final BarcodeDatabase _database;

  BarcodeRepositoryImpl(this._database);

  @override
  Future<BarcodeModel?> findByCode(String code) async {
    LoggerService.d('findByCode: $code', tag: _tag);
    final result = await _database.findByCode(code);
    LoggerService.d(
      result != null
          ? 'Found: ${result.code} (id=${result.id})'
          : 'Not found: $code',
      tag: _tag,
    );
    return result;
  }

  @override
  Future<void> markAsUsed(int id) async {
    LoggerService.i('markAsUsed: id=$id', tag: _tag);
    await _database.markAsUsed(id);
    LoggerService.i('Marked as used: id=$id', tag: _tag);
  }

  @override
  Future<List<BarcodeModel>> getAllBarcodes() async {
    LoggerService.d('getAllBarcodes', tag: _tag);
    final result = await _database.getAllBarcodes();
    LoggerService.d('Returned ${result.length} barcodes', tag: _tag);
    return result;
  }

  @override
  Future<Map<String, int>> getBarcodeStats() async {
    LoggerService.d('getBarcodeStats', tag: _tag);
    final stats = await _database.getBarcodeStats();
    LoggerService.d(
      'Stats: total=${stats['total']}, used=${stats['used']}, available=${stats['available']}, today=${stats['todayScanned']}',
      tag: _tag,
    );
    return stats;
  }
}

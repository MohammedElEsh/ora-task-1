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
    return await _database.findByCode(code);
  }

  @override
  Future<void> markAsUsed(int id) async {
    LoggerService.i('markAsUsed: id=$id', tag: _tag);
    await _database.markAsUsed(id);
  }

  @override
  Future<List<BarcodeModel>> getAllBarcodes() async {
    LoggerService.d('getAllBarcodes', tag: _tag);
    return await _database.getAllBarcodes();
  }

  @override
  Future<Map<String, int>> getBarcodeStats() async {
    LoggerService.d('getBarcodeStats', tag: _tag);
    return await _database.getBarcodeStats();
  }
}

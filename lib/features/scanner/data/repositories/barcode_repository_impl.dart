import '../datasources/barcode_database.dart';
import '../models/barcode_model.dart';
import 'barcode_repository.dart';

class BarcodeRepositoryImpl implements BarcodeRepository {
  final BarcodeDatabase _database;

  BarcodeRepositoryImpl(this._database);

  @override
  Future<BarcodeModel?> findByCode(String code) async {
    return await _database.findByCode(code);
  }

  @override
  Future<void> markAsUsed(int id) async {
    await _database.markAsUsed(id);
  }

  @override
  Future<void> insertBarcode(BarcodeModel barcode) async {
    await _database.insertBarcode(barcode);
  }

  @override
  Future<List<BarcodeModel>> getAllBarcodes() async {
    return await _database.getAllBarcodes();
  }

  @override
  Future<void> deleteBarcode(int id) async {
    await _database.deleteBarcode(id);
  }

  @override
  Future<void> clearAll() async {
    await _database.clearAll();
  }

  @override
  Future<void> seedDemoData() async {
    await _database.seedDemoData();
  }
}

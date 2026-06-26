import '../models/barcode_model.dart';

abstract class BarcodeRepository {
  Future<BarcodeModel?> findByCode(String code);
  Future<void> markAsUsed(int id);
  Future<List<BarcodeModel>> getAllBarcodes();
  Future<Map<String, int>> getBarcodeStats();
}

import '../models/barcode_model.dart';

abstract class BarcodeRepository {
  Future<BarcodeModel?> findByCode(String code);

  Future<void> markAsUsed(int id);

  Future<void> insertBarcode(BarcodeModel barcode);

  Future<List<BarcodeModel>> getAllBarcodes();

  Future<void> deleteBarcode(int id);

  Future<void> clearAll();

  Future<void> seedDemoData();
}

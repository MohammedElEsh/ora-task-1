import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../data/repositories/barcode_repository.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._repository) : super(const ScannerInitial());

  final BarcodeRepository _repository;
  static const _tag = 'ScannerCubit';

  Future<void> loadStats() async {
    LoggerService.d('Loading stats', tag: _tag);
    try {
      final stats = await _repository.getBarcodeStats();
      emit(ScannerStatsLoaded(
        total: stats['total'] ?? 0,
        used: stats['used'] ?? 0,
        available: stats['available'] ?? 0,
        todayScanned: stats['todayScanned'] ?? 0,
      ));
      LoggerService.d(
        'Stats loaded: total=${stats['total']}, used=${stats['used']}, available=${stats['available']}, today=${stats['todayScanned']}',
        tag: _tag,
      );
    } catch (e) {
      LoggerService.e('Failed to load stats', error: e, tag: _tag);
      emit(const ScanError('Failed to load statistics'));
    }
  }

  Future<void> onBarcodeScanned(String code) async {
    if (code.isEmpty) return;

    LoggerService.d('Barcode scanned: $code', tag: _tag);
    emit(const ScannerLoading());

    try {
      final barcode = await _repository.findByCode(code);

      if (barcode == null) {
        LoggerService.w('Barcode not found: $code', tag: _tag);
        emit(ScanNotFound(code));
        return;
      }

      if (barcode.isUsed) {
        LoggerService.w('Barcode already used: $code', tag: _tag);
        emit(ScanAlreadyUsed(barcode));
        return;
      }

      final id = barcode.id;
      if (id == null) {
        LoggerService.e('Barcode has null id: $code', tag: _tag);
        emit(const ScanError('Invalid barcode data'));
        return;
      }

      await _repository.markAsUsed(id);
      final updatedBarcode = barcode.copyWith(isUsed: true);
      LoggerService.i('Barcode accepted: $code', tag: _tag);
      emit(ScanAccepted(updatedBarcode));
    } catch (e) {
      LoggerService.e('Scan error', error: e, tag: _tag);
      emit(const ScanError('Scan failed. Please try again.'));
    }
  }

  void resetScanner() {
    emit(const ScannerInitial());
  }
}

class TestQrCubit extends Cubit<TestQrState> {
  TestQrCubit(this._repository) : super(const TestQrInitial());

  final BarcodeRepository _repository;
  static const _tag = 'TestQrCubit';

  Future<void> loadBarcodes() async {
    LoggerService.d('Loading barcodes', tag: _tag);
    emit(const TestQrLoading());
    try {
      final barcodes = await _repository.getAllBarcodes();
      final availableCount = barcodes.where((b) => !b.isUsed).length;
      final usedCount = barcodes.where((b) => b.isUsed).length;
      LoggerService.d('Loaded ${barcodes.length} barcodes', tag: _tag);
      emit(TestQrLoaded(
        barcodes: barcodes,
        availableCount: availableCount,
        usedCount: usedCount,
      ));
    } catch (e) {
      LoggerService.e('Failed to load barcodes', error: e, tag: _tag);
      emit(TestQrError(e.toString()));
    }
  }
}

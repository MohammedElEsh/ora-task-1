import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../data/repositories/barcode_repository.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._repository) : super(const ScannerInitial());
  final BarcodeRepository _repository;
  static const _tag = 'ScannerCubit';

  Future<void> loadStats() async {
    LoggerService.d('loadStats() called', tag: _tag);
    try {
      final s = await _repository.getBarcodeStats();
      LoggerService.d('Stats received: $s', tag: _tag);
      emit(ScannerStatsLoaded(
        total: s['total'] ?? 0,
        used: s['used'] ?? 0,
        available: s['available'] ?? 0,
        todayScanned: s['todayScanned'] ?? 0,
      ));
      LoggerService.d('Emitted ScannerStatsLoaded', tag: _tag);
    } catch (e) {
      LoggerService.e('loadStats failed', error: e, tag: _tag);
      emit(const ScanError('Failed to load statistics'));
    }
  }

  Future<void> onBarcodeScanned(String code) async {
    LoggerService.i('onBarcodeScanned("$code") called', tag: _tag);
    if (code.isEmpty) {
      LoggerService.w('Empty code, skipping', tag: _tag);
      return;
    }
    emit(const ScannerLoading());
    LoggerService.d('Emitted ScannerLoading', tag: _tag);

    try {
      final barcode = await _repository.findByCode(code);
      LoggerService.d('findByCode result: ${barcode != null ? "found id=${barcode.id}" : "null"}', tag: _tag);

      if (barcode == null) {
        LoggerService.w('Barcode not found: $code', tag: _tag);
        emit(ScanNotFound(code));
        LoggerService.d('Emitted ScanNotFound', tag: _tag);
        return;
      }

      if (barcode.isUsed) {
        LoggerService.w('Barcode already used: $code (used at ${barcode.usedAt})', tag: _tag);
        emit(ScanAlreadyUsed(barcode));
        LoggerService.d('Emitted ScanAlreadyUsed', tag: _tag);
        return;
      }

      final id = barcode.id;
      if (id == null) {
        LoggerService.e('Barcode has null id: $code', tag: _tag);
        emit(const ScanError('Invalid barcode data'));
        return;
      }

      LoggerService.i('Marking barcode as used: id=$id, code=$code', tag: _tag);
      await _repository.markAsUsed(id);
      final updated = barcode.copyWith(isUsed: true);
      LoggerService.i('Barcode accepted: $code', tag: _tag);
      emit(ScanAccepted(updated));
      LoggerService.d('Emitted ScanAccepted', tag: _tag);
    } catch (e) {
      LoggerService.e('Scan error for code=$code', error: e, tag: _tag);
      emit(const ScanError('Scan failed. Please try again.'));
    }
  }

  void resetScanner() {
    LoggerService.d('resetScanner() called', tag: _tag);
    emit(const ScannerInitial());
    LoggerService.d('Emitted ScannerInitial', tag: _tag);
  }
}

class TestQrCubit extends Cubit<TestQrState> {
  TestQrCubit(this._repository) : super(const TestQrInitial());
  final BarcodeRepository _repository;
  static const _tag = 'TestQrCubit';

  Future<void> loadBarcodes() async {
    LoggerService.d('loadBarcodes() called', tag: _tag);
    emit(const TestQrLoading());
    try {
      final barcodes = await _repository.getAllBarcodes();
      final available = barcodes.where((b) => !b.isUsed).length;
      final used = barcodes.where((b) => b.isUsed).length;
      LoggerService.d('Barcodes loaded: ${barcodes.length} total, $available available, $used used', tag: _tag);
      emit(TestQrLoaded(barcodes: barcodes, availableCount: available, usedCount: used));
    } catch (e) {
      LoggerService.e('loadBarcodes failed', error: e, tag: _tag);
      emit(TestQrError(e.toString()));
    }
  }
}

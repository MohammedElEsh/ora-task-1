import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../data/repositories/barcode_repository.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._repository) : super(const ScannerInitial());

  final BarcodeRepository _repository;

  Future<void> onBarcodeScanned(String code) async {
    if (code.isEmpty) return;

    LoggerService.d('Barcode scanned: $code', tag: 'ScannerCubit');
    emit(const ScannerLoading());

    try {
      final barcode = await _repository.findByCode(code);

      if (barcode == null) {
        LoggerService.w('Barcode not found: $code', tag: 'ScannerCubit');
        emit(ScanNotFound(code));
        return;
      }

      if (barcode.isUsed) {
        LoggerService.w('Barcode already used: $code', tag: 'ScannerCubit');
        emit(ScanAlreadyUsed(barcode));
        return;
      }

      await _repository.markAsUsed(barcode.id!);
      final updatedBarcode = barcode.copyWith(isUsed: true);
      LoggerService.i('Barcode accepted: $code', tag: 'ScannerCubit');
      emit(ScanAccepted(updatedBarcode));
    } catch (e) {
      LoggerService.e('Scan error', error: e, tag: 'ScannerCubit');
      emit(ScanError(e.toString()));
    }
  }

  void resetScanner() {
    emit(const ScannerInitial());
  }
}

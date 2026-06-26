import 'package:equatable/equatable.dart';
import '../../data/models/barcode_model.dart';

sealed class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

class ScannerLoading extends ScannerState {
  const ScannerLoading();
}

class ScannerStatsLoaded extends ScannerState {
  final int total;
  final int used;
  final int available;
  final int todayScanned;

  const ScannerStatsLoaded({
    required this.total,
    required this.used,
    required this.available,
    required this.todayScanned,
  });

  @override
  List<Object?> get props => [total, used, available, todayScanned];
}

class ScanAccepted extends ScannerState {
  final BarcodeModel barcode;
  const ScanAccepted(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

class ScanAlreadyUsed extends ScannerState {
  final BarcodeModel barcode;
  const ScanAlreadyUsed(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

class ScanNotFound extends ScannerState {
  final String code;
  const ScanNotFound(this.code);

  @override
  List<Object?> get props => [code];
}

class ScanError extends ScannerState {
  final String message;
  const ScanError(this.message);

  @override
  List<Object?> get props => [message];
}

sealed class TestQrState extends Equatable {
  const TestQrState();

  @override
  List<Object?> get props => [];
}

class TestQrInitial extends TestQrState {
  const TestQrInitial();
}

class TestQrLoading extends TestQrState {
  const TestQrLoading();
}

class TestQrLoaded extends TestQrState {
  final List<BarcodeModel> barcodes;
  final int availableCount;
  final int usedCount;

  const TestQrLoaded({
    required this.barcodes,
    required this.availableCount,
    required this.usedCount,
  });

  @override
  List<Object?> get props => [barcodes, availableCount, usedCount];
}

class TestQrError extends TestQrState {
  final String message;

  const TestQrError(this.message);

  @override
  List<Object?> get props => [message];
}

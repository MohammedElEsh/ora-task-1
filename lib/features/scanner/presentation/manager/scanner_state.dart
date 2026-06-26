import 'package:equatable/equatable.dart';

import '../../data/models/barcode_model.dart';

// ── Scanner states ──────────────────────────────────────────────────
sealed class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

/// Idle state — camera is ready, no scan in progress.
class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

/// Scan in progress.
class ScannerLoading extends ScannerState {
  const ScannerLoading();
}

/// Stats loaded successfully.
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

/// Barcode accepted.
class ScanAccepted extends ScannerState {
  final BarcodeModel barcode;

  const ScanAccepted(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

/// Barcode already scanned.
class ScanAlreadyUsed extends ScannerState {
  final BarcodeModel barcode;

  const ScanAlreadyUsed(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

/// Invalid ticket.
class ScanNotFound extends ScannerState {
  final String code;

  const ScanNotFound(this.code);

  @override
  List<Object?> get props => [code];
}

/// Unexpected error during scan (DB failure, etc.).
class ScanError extends ScannerState {
  final String message;

  const ScanError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Test QR states ──────────────────────────────────────────────────

sealed class TestQrState extends Equatable {
  const TestQrState();

  @override
  List<Object?> get props => [];
}

/// Sheet just opened, no data yet.
class TestQrInitial extends TestQrState {
  const TestQrInitial();
}

/// fetching barcodes from the database.
class TestQrLoading extends TestQrState {
  const TestQrLoading();
}

/// Barcodes ready to display the list.
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

/// Failed to load barcodes.
class TestQrError extends TestQrState {
  final String message;

  const TestQrError(this.message);

  @override
  List<Object?> get props => [message];
}

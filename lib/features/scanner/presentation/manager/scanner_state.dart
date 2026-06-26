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

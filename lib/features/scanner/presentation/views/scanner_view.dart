import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../data/repositories/barcode_repository.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
import '../widgets/scan_instruction.dart';
import '../widgets/scan_overlay.dart';
import '../widgets/scan_result_overlay.dart';
import '../widgets/scanner_bottom_bar.dart';
import '../widgets/scanner_top_bar.dart';
import 'test_qr_view.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  static const _tag = 'ScannerView';
  late MobileScannerController _controller;
  bool _isScannerActive = true;
  int _scannedToday = 0;
  int _totalScanned = 0;
  bool _isProcessing = false;
  Timer? _resultTimer;
  Timer? _cooldownTimer;

  Color _frameBorderColor = Colors.white;

  @override
  void initState() {
    super.initState();
    LoggerService.i('ScannerView initialized', tag: _tag);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: true,
    );
    _isScannerActive = true;
    _loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('ScannerView disposed', tag: _tag);
    _resultTimer?.cancel();
    _cooldownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    LoggerService.d('Loading scan stats', tag: _tag);
    try {
      final barcodes = await sl<BarcodeRepository>().getAllBarcodes();
      final today = DateTime.now();
      final todayScanned = barcodes.where((b) {
        if (!b.isUsed || b.usedAt == null) return false;
        final usedDate = b.usedAt!;
        return usedDate.year == today.year &&
            usedDate.month == today.month &&
            usedDate.day == today.day;
      }).length;

      if (mounted) {
        setState(() {
          _scannedToday = todayScanned;
          _totalScanned = barcodes.where((b) => b.isUsed).length;
        });
        LoggerService.d('Stats loaded: today=$_scannedToday, total=$_totalScanned', tag: _tag);
      }
    } catch (e) {
      LoggerService.e('Failed to load stats', error: e, tag: _tag);
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;
    LoggerService.d('Barcode detected: ${barcode.rawValue}', tag: _tag);
    _processBarcode(barcode.rawValue!);
  }

  void _processBarcode(String code) {
    if (_isProcessing) return;
    LoggerService.i('Processing barcode: $code', tag: _tag);
    setState(() => _isProcessing = true);
    context.read<ScannerCubit>().onBarcodeScanned(code);
  }

  void _playFeedback(ScannerState state) {
    if (state is ScanAccepted) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
  }

  void _resetScan() {
    LoggerService.d('Resetting scanner', tag: _tag);
    context.read<ScannerCubit>().resetScanner();
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<ScannerCubit, ScannerState>(
        listener: (context, state) {
          LoggerService.d('State changed: ${state.runtimeType}', tag: _tag);
          if (state is ScannerInitial) {
            setState(() {
              _frameBorderColor = Colors.white;
            });
          } else if (state is ScanAccepted ||
              state is ScanAlreadyUsed ||
              state is ScanNotFound ||
              state is ScanError) {
            _playFeedback(state);

            Color newBorder;
            if (state is ScanAccepted) {
              _loadStats();
              newBorder = AppColors.validGreen;
            } else if (state is ScanAlreadyUsed || state is ScanError) {
              _loadStats();
              newBorder = AppColors.deniedRed;
            } else {
              newBorder = AppColors.invalidOrange;
            }

            setState(() {
              _frameBorderColor = newBorder;
            });

            _resultTimer?.cancel();
            _resultTimer = Timer(const Duration(seconds: 3), () {
              if (!mounted) return;
              context.read<ScannerCubit>().resetScanner();
              _cooldownTimer?.cancel();
              _cooldownTimer = Timer(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isProcessing = false;
                    _frameBorderColor = Colors.white;
                  });
                }
              });
            });
          }
        },
        child: BlocBuilder<ScannerCubit, ScannerState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: _isScannerActive
                      ? MobileScanner(
                          controller: _controller,
                          onDetect: _onBarcodeDetected,
                        )
                      : Container(
                          color: Colors.black,
                          child: Center(
                            child: Icon(
                              Icons.videocam_off_outlined,
                              color: Colors.white38,
                              size: 48.r,
                            ),
                          ),
                        ),
                ),
                if (_isScannerActive)
                  Positioned.fill(
                    child: ScanOverlay(borderColor: _frameBorderColor),
                  ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.h,
                  left: 0,
                  right: 0,
                  child: ScannerTopBar(
                    eventName: 'Music Festival 2026',
                    location: 'Main Gate',
                    pendingSyncCount: 0,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 70.h,
                  left: 0,
                  right: 0,
                  child: (state is ScannerInitial || state is ScannerLoading)
                      ? const ScanInstruction()
                      : const SizedBox.shrink(),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  left: 20.w,
                  right: 20.w,
                  bottom: (state is ScannerInitial || state is ScannerLoading)
                      ? -180.h
                      : MediaQuery.of(context).padding.bottom + 100.h,
                  child: ScanResultOverlay(state: state, onDismiss: _resetScan),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ScannerBottomBar(
                    isTorchOn: _controller.value.torchState == TorchState.on,
                    scannedToday: _scannedToday,
                    totalScanned: _totalScanned,
                    onToggleTorch: () async {
                      await _controller.toggleTorch();
                      setState(() {});
                    },
                    onTestTap: () async {
                      final code = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const TestQrView(),
                      );
                      if (code != null && mounted) {
                        _processBarcode(code);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

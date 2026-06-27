import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
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
  late MobileScannerController _camera;
  late final ScannerCubit _cubit;
  bool _processing = false; // prevents multiple scans at once
  Timer? _resetTimer; // 3-second cooldown after each scan
  Color _borderColor = Colors.white;

  @override
  void initState() {
    super.initState();
    LoggerService.i('Initialized', tag: _tag);
    _cubit = context.read<ScannerCubit>();

    _camera = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: true,
    );
    LoggerService.d('Camera controller created', tag: _tag);

    _cubit.loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('Disposed', tag: _tag);
    _resetTimer?.cancel();
    _camera.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing) {
      LoggerService.d('Scan ignored (processing)', tag: _tag);
      return;
    }
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) {
      LoggerService.d('No barcode in capture', tag: _tag);
      return;
    }
    LoggerService.i('Barcode detected: "$code"', tag: _tag);

    setState(() => _processing = true);
    _cubit.onBarcodeScanned(code);
  }

  void _onScanResult(ScannerState state) {
    LoggerService.d('State change: ${state.runtimeType}', tag: _tag);

    if (state is ScannerInitial) {
      setState(() => _borderColor = Colors.white);
      LoggerService.d('Border → white (initial)', tag: _tag);
      return;
    }
    if (state is ScannerStatsLoaded) {
      LoggerService.d(
        'Stats loaded: today=${state.todayScanned}, used=${state.used}',
        tag: _tag,
      );
      return;
    }

    // Vibrate the device for tactile feedback
    HapticFeedback.vibrate();

    // Set the overlay border colour based on the scan outcome
    final color = switch (state) {
      ScanAccepted() => AppColors.validGreen,
      ScanAlreadyUsed() || ScanError() => AppColors.deniedRed,
      ScanNotFound() => AppColors.invalidOrange,
      _ => Colors.white,
    };
    LoggerService.d(
      'Border → ${color == AppColors.validGreen
          ? "green"
          : color == AppColors.deniedRed
          ? "red"
          : "orange"}',
      tag: _tag,
    );
    setState(() => _borderColor = color);

    // Start a 3-second timer
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      LoggerService.d('Reset timer fired, resetting scanner', tag: _tag);
      if (!mounted) return;
      _cubit.resetScanner();
      _cubit.loadStats();
      Future.delayed(const Duration(seconds: 1), () {
        LoggerService.d('Cooldown complete, re-enabling scanner', tag: _tag);
        if (mounted) setState(() => _processing = false);
      });
    });
  }

  void _dismiss() {
    LoggerService.d('Result dismissed by user', tag: _tag);
    _cubit.resetScanner();
    setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.d('Building UI', tag: _tag);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<ScannerCubit, ScannerState>(
        listener: (context, state) => _onScanResult(state),
        child: BlocBuilder<ScannerCubit, ScannerState>(
          builder: (context, state) {
            final today = state is ScannerStatsLoaded ? state.todayScanned : 0;
            final total = state is ScannerStatsLoaded ? state.used : 0;
            final isIdle = state is ScannerInitial || state is ScannerLoading;

            return Stack(
              children: [
                // Layer 1: Live camera
                Positioned.fill(
                  child: MobileScanner(
                    controller: _camera,
                    onDetect: _onDetect,
                  ),
                ),

                // Layer 2: Scan frame cut-out
                Positioned.fill(child: ScanOverlay(borderColor: _borderColor)),

                // Layer 3: Top bar (back button + event badge)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.h,
                  left: 0,
                  right: 0,
                  child: ScannerTopBar(
                    eventName: 'Music Festival 2026',
                    location: 'Main Gate',
                    pendingSyncCount: 0,
                    onBack: () {
                      LoggerService.d('Back pressed', tag: _tag);
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Layer 4: Scan instruction text
                Positioned(
                  top: MediaQuery.of(context).padding.top + 100.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.center_focus_strong_rounded,
                          color: Colors.white70,
                          size: 32.r,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Align QR code within the frame',
                          style: AppTypography.medium14.copyWith(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Hold steady for automatic detection',
                          style: AppTypography.regular12.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Layer 5: Scan result card
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: isIdle
                      ? -180.h
                      : MediaQuery.of(context).padding.bottom + 100.h,
                  child: ScanResultOverlay(state: state, onDismiss: _dismiss),
                ),

                // Layer 6: Bottom bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ScannerBottomBar(
                    isTorchOn: _camera.value.torchState == TorchState.on,
                    scannedToday: today,
                    totalScanned: total,
                    onToggleTorch: () async {
                      LoggerService.d('Torch toggle', tag: _tag);
                      await _camera.toggleTorch();
                      setState(() {});
                    },
                    onTestTap: () async {
                      LoggerService.d(
                        'Test QR tapped, opening bottom sheet',
                        tag: _tag,
                      );
                      final code = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const TestQrView(),
                      );
                      LoggerService.d(
                        'Bottom sheet returned: "$code"',
                        tag: _tag,
                      );
                      if (code != null && mounted) {
                        LoggerService.i(
                          'Processing test barcode: "$code"',
                          tag: _tag,
                        );
                        setState(() => _processing = true);
                        _cubit.onBarcodeScanned(code);
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

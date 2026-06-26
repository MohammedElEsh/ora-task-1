/// Home / landing screen for the gate scanner.
///
/// Displays event details, ticket statistics (total / used / available),
/// and a large scan button that navigates to [ScannerView]. Stats are
/// reloaded every time the user returns from scanning.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
import '../widgets/event_info_card.dart';
import '../widgets/scan_qr_button.dart';
import '../widgets/stat_card.dart';
import 'scanner_view.dart';

class EventPreparationView extends StatefulWidget {
  const EventPreparationView({super.key});

  @override
  State<EventPreparationView> createState() => _EventPreparationViewState();
}

class _EventPreparationViewState extends State<EventPreparationView> {
  static const _tag = 'PrepView';
  late final ScannerCubit _cubit;

  @override
  void initState() {
    super.initState();
    LoggerService.i('Initialized', tag: _tag);
    // Create cubit and immediately load stats for the home screen
    _cubit = sl<ScannerCubit>()..loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('Disposed', tag: _tag);
    // Always close cubits to prevent memory leaks
    _cubit.close();
    super.dispose();
  }

  /// Navigates to the scanner screen.
  /// When the user returns, reload stats to reflect any new scans.
  void _openScanner() {
    LoggerService.i('Navigating to ScannerView', tag: _tag);
    Navigator.push(
      context,
      MaterialPageRoute(
        // Provide a fresh cubit for the scanner screen
        builder: (_) => BlocProvider(
          create: (_) => sl<ScannerCubit>(),
          child: const ScannerView(),
        ),
      ),
    ).then((_) {
      // `.then` fires when ScannerView is popped
      LoggerService.d('Returned from ScannerView, reloading stats', tag: _tag);
      if (mounted) _cubit.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.d('Building UI', tag: _tag);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.r),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              _header(),           // App title + icon row
              SizedBox(height: 24.h),
              // Event details card (hardcoded for demo)
              const EventInfoCard(
                eventName: 'Music Festival 2026',
                venue: 'Cairo International Stadium',
                date: 'Sunday, June 28, 2026',
                time: '8:00 PM',
                gateNumber: 'Gate 3',
              ),
              SizedBox(height: 50.h),
              // Stats row — rebuilds whenever cubit emits a new state
              BlocBuilder<ScannerCubit, ScannerState>(
                bloc: _cubit,
                builder: (context, state) {
                  // Extract stats if loaded, otherwise use zeros
                  final s = state is ScannerStatsLoaded ? state : null;
                  LoggerService.d('Stats: total=${s?.total}, used=${s?.used}, available=${s?.available}', tag: _tag);
                  return _stats(total: s?.total ?? 0, used: s?.used ?? 0, available: s?.available ?? 0);
                },
              ),
              const Spacer(),
              // Large scan button at the bottom
              ScanQrButton(onTap: _openScanner),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Top row: app icon + "Gate Scanner" title
  Widget _header() => Row(
    children: [
      // Blue gradient icon container
      Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 26.r),
      ),
      SizedBox(width: 14.w),
      // Title + subtitle
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gate Scanner', style: AppTypography.semiBold20),
            SizedBox(height: 4.h),
            Text('Ready to scan tickets', style: AppTypography.regular14.copyWith(color: const Color(0xFF64748B))),
          ],
        ),
      ),
    ],
  );

  /// Three stat cards in a row: Total / Used / Available
  Widget _stats({required int total, required int used, required int available}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ticket Statistics', style: AppTypography.semiBold16),
      SizedBox(height: 12.h),
      Row(
        children: [
          Expanded(child: StatCard(title: 'Total', value: '$total', icon: Icons.confirmation_number_rounded, color: AppColors.primary, bgColor: AppColors.primary10)),
          SizedBox(width: 12.w),
          Expanded(child: StatCard(title: 'Used', value: '$used', icon: Icons.check_circle_rounded, color: AppColors.validGreen, bgColor: AppColors.success10)),
          SizedBox(width: 12.w),
          Expanded(child: StatCard(title: 'Available', value: '$available', icon: Icons.event_available_rounded, color: AppColors.warning, bgColor: AppColors.warning10)),
        ],
      ),
    ],
  );
}

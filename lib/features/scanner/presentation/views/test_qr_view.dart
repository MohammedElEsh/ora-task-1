/// Bottom sheet for simulating a QR scan without a real camera.
///
/// Lists all barcodes from the database with their status (available / used)
/// plus one hardcoded invalid code ("TKT-999"). Tapping a row pops the
/// sheet and returns the selected code to [ScannerView] for processing.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
import '../widgets/stat_card.dart';
import '../widgets/test_qr_ticket_list.dart';

class TestQrView extends StatelessWidget {
  const TestQrView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.d('TestQrView.build()', tag: 'TestQrView');
    return BlocProvider(
      create: (_) {
        // Create a fresh TestQrCubit and load barcodes immediately
        LoggerService.i('Creating TestQrCubit', tag: 'TestQrView');
        return sl<TestQrCubit>()..loadBarcodes();
      },
      child: const _SheetContent(),
    );
  }
}

class _SheetContent extends StatelessWidget {
  const _SheetContent();

  @override
  Widget build(BuildContext context) {
    LoggerService.d('_SheetContent.build()', tag: 'TestQrView');
    return Container(
      // Limit height to 75% of screen so it doesn't cover everything
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sheet(),      // Small drag handle at the top
          _header(),     // "Test Scanner" title + subtitle
          SizedBox(height: 8.h),
          // Available / Used / Invalid stat badges
          BlocBuilder<TestQrCubit, TestQrState>(
            builder: (context, state) {
              final s = state is TestQrLoaded ? state : null;
              LoggerService.d(
                'Stats: available=${s?.availableCount}, used=${s?.usedCount}',
                tag: 'TestQrView',
              );
              return _stats(
                available: s?.availableCount ?? 0,
                used: s?.usedCount ?? 0,
              );
            },
          ),
          SizedBox(height: 8.h),
          // Scrollable list of barcodes (or loading spinner / error)
          Flexible(
            child: BlocBuilder<TestQrCubit, TestQrState>(
              builder: (context, state) {
                // Loading state → show spinner
                if (state is TestQrLoading) {
                  LoggerService.d('Loading barcodes...', tag: 'TestQrView');
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                // Loaded → show the ticket list
                if (state is TestQrLoaded) {
                  LoggerService.d(
                    'Loaded ${state.barcodes.length} barcodes',
                    tag: 'TestQrView',
                  );
                  return TestQrTicketList(barcodes: state.barcodes);
                }
                // Error → show error icon + retry button
                if (state is TestQrError) {
                  LoggerService.e('Error: ${state.message}', tag: 'TestQrView');
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 8.h),
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              LoggerService.d(
                                'Retry tapped',
                                tag: 'TestQrView',
                              );
                              // Retry the load
                              context.read<TestQrCubit>().loadBarcodes();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // Initial state → nothing visible
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Small grey pill at the top — visual cue that the sheet is draggable
  Widget _sheet() => Padding(
    padding: EdgeInsets.only(top: 12.h),
    child: Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2.r),
      ),
    ),
  );

  /// Title: "Test Scanner" + subtitle
  Widget _header() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test Scanner', style: AppTypography.semiBold18),
        SizedBox(height: 6.h),
        Text(
          'Select a ticket to simulate scanning',
          style: AppTypography.regular14.copyWith(color: AppColors.grey500),
        ),
      ],
    ),
  );

  /// Three stat badges: Available (green) / Used (red) / Invalid (orange)
  Widget _stats({required int available, required int used}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Row(
      children: [
        Expanded(
          child: StatBadge(
            count: available,
            label: 'Available',
            color: AppColors.validGreen,
            bgColor: AppColors.validGreenBg,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatBadge(
            count: used,
            label: 'Used',
            color: AppColors.deniedRed,
            bgColor: AppColors.deniedRedBg,
          ),
        ),
        SizedBox(width: 12.w),
        // Hardcoded "1" invalid ticket (TKT-999)
        const Expanded(
          child: StatBadge(
            count: 1,
            label: 'Invalid',
            color: AppColors.invalidOrange,
            bgColor: AppColors.invalidOrangeBg,
          ),
        ),
      ],
    ),
  );
}

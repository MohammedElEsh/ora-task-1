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
          _sheet(),
          _header(),
          SizedBox(height: 8.h),
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
          Flexible(
            child: BlocBuilder<TestQrCubit, TestQrState>(
              builder: (context, state) {
                if (state is TestQrLoading) {
                  LoggerService.d('Loading barcodes...', tag: 'TestQrView');
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TestQrLoaded) {
                  LoggerService.d(
                    'Loaded ${state.barcodes.length} barcodes',
                    tag: 'TestQrView',
                  );
                  return TestQrTicketList(barcodes: state.barcodes);
                }
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
                              context.read<TestQrCubit>().loadBarcodes();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

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

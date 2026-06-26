import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
import '../widgets/bottom_sheet_handle.dart';
import '../widgets/test_qr_header.dart';
import '../widgets/test_qr_stats.dart';
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
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          const TestQrHeader(),
          SizedBox(height: 8.h),
          BlocBuilder<TestQrCubit, TestQrState>(
            builder: (context, state) {
              final s = state is TestQrLoaded ? state : null;
              LoggerService.d('Stats: available=${s?.availableCount}, used=${s?.usedCount}', tag: 'TestQrView');
              return TestQrStats(available: s?.availableCount ?? 0, used: s?.usedCount ?? 0);
            },
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: BlocBuilder<TestQrCubit, TestQrState>(
              builder: (context, state) {
                if (state is TestQrLoading) {
                  LoggerService.d('Loading barcodes...', tag: 'TestQrView');
                  return SizedBox(height: 200.h, child: const Center(child: CircularProgressIndicator()));
                }
                if (state is TestQrLoaded) {
                  LoggerService.d('Loaded ${state.barcodes.length} barcodes', tag: 'TestQrView');
                  return RefreshIndicator(
                    onRefresh: () {
                      LoggerService.d('Refresh triggered', tag: 'TestQrView');
                      return context.read<TestQrCubit>().loadBarcodes();
                    },
                    child: TestQrTicketList(barcodes: state.barcodes),
                  );
                }
                if (state is TestQrError) {
                  LoggerService.e('Error: ${state.message}', tag: 'TestQrView');
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          SizedBox(height: 8.h),
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              LoggerService.d('Retry tapped', tag: 'TestQrView');
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
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }
}

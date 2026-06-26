import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
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
    return BlocProvider(
      create: (context) => sl<TestQrCubit>()..loadBarcodes(),
      child: const _TestQrContent(),
    );
  }
}

class _TestQrContent extends StatelessWidget {
  const _TestQrContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          const TestQrHeader(),
          SizedBox(height: 8.h),
          BlocBuilder<TestQrCubit, TestQrState>(
            builder: (context, state) {
              final available = state is TestQrLoaded ? state.availableCount : 0;
              final used = state is TestQrLoaded ? state.usedCount : 0;
              return TestQrStats(available: available, used: used);
            },
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: BlocBuilder<TestQrCubit, TestQrState>(
              builder: (context, state) {
                if (state is TestQrLoading) {
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TestQrLoaded) {
                  return RefreshIndicator(
                    onRefresh: () => context.read<TestQrCubit>().loadBarcodes(),
                    child: TestQrTicketList(barcodes: state.barcodes),
                  );
                }
                if (state is TestQrError) {
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
                            onPressed: () => context.read<TestQrCubit>().loadBarcodes(),
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

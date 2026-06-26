import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../manager/scanner_cubit.dart';
import '../manager/scanner_state.dart';
import '../widgets/event_info_card.dart';
import '../widgets/prep_header.dart';
import '../widgets/prep_stats_section.dart';
import '../widgets/scan_qr_button.dart';
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
    _cubit = sl<ScannerCubit>()..loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('Disposed', tag: _tag);
    _cubit.close();
    super.dispose();
  }

  void _openScanner() {
    LoggerService.i('Navigating to ScannerView', tag: _tag);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ScannerCubit>(),
          child: const ScannerView(),
        ),
      ),
    ).then((_) {
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
              const PrepHeader(),
              SizedBox(height: 24.h),
              const EventInfoCard(
                eventName: 'Music Festival 2026',
                venue: 'Cairo International Stadium',
                date: 'Sunday, June 28, 2026',
                time: '8:00 PM',
                gateNumber: 'Gate 3',
              ),
              SizedBox(height: 50.h),
              BlocBuilder<ScannerCubit, ScannerState>(
                bloc: _cubit,
                builder: (context, state) {
                  final s = state is ScannerStatsLoaded ? state : null;
                  LoggerService.d('Stats state: total=${s?.total}, used=${s?.used}, available=${s?.available}', tag: _tag);
                  return PrepStatsSection(
                    totalTickets: s?.total ?? 0,
                    usedTickets: s?.used ?? 0,
                    availableTickets: s?.available ?? 0,
                  );
                },
              ),
              const Spacer(),
              ScanQrButton(onTap: _openScanner),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

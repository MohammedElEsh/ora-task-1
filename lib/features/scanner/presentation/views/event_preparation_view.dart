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
  static const _tag = 'EventPreparationView';
  late final ScannerCubit _cubit;

  @override
  void initState() {
    super.initState();
    LoggerService.i('EventPreparationView initialized', tag: _tag);
    _cubit = sl<ScannerCubit>()..loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('EventPreparationView disposed', tag: _tag);
    _cubit.close();
    super.dispose();
  }

  void _navigateToScanner(BuildContext context) {
    LoggerService.i('Navigating to scanner', tag: _tag);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<ScannerCubit>(),
          child: const ScannerView(),
        ),
      ),
    ).then((_) {
      if (mounted) _cubit.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  final total = state is ScannerStatsLoaded ? state.total : 0;
                  final used = state is ScannerStatsLoaded ? state.used : 0;
                  final available = state is ScannerStatsLoaded
                      ? state.available
                      : 0;
                  return PrepStatsSection(
                    totalTickets: total,
                    usedTickets: used,
                    availableTickets: available,
                  );
                },
              ),
              SizedBox(height: 64.h),
              ScanQrButton(onTap: () => _navigateToScanner(context)),
            ],
          ),
        ),
      ),
    );
  }
}

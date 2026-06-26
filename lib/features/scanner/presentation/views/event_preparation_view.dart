import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../data/repositories/barcode_repository.dart';
import '../manager/scanner_cubit.dart';
import '../widgets/event_info_card.dart';
import '../widgets/prep_bottom_button.dart';
import '../widgets/prep_header.dart';
import '../widgets/prep_stats_section.dart';
import 'scanner_view.dart';

class EventPreparationView extends StatefulWidget {
  const EventPreparationView({super.key});

  @override
  State<EventPreparationView> createState() => _EventPreparationViewState();
}

class _EventPreparationViewState extends State<EventPreparationView>
    with WidgetsBindingObserver {
  static const _tag = 'EventPreparationView';
  int _totalTickets = 0;
  int _usedTickets = 0;
  int _availableTickets = 0;

  @override
  void initState() {
    super.initState();
    LoggerService.i('EventPreparationView initialized', tag: _tag);
    WidgetsBinding.instance.addObserver(this);
    _loadStats();
  }

  @override
  void dispose() {
    LoggerService.d('EventPreparationView disposed', tag: _tag);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LoggerService.d('App resumed, reloading stats', tag: _tag);
      _loadStats();
    }
  }

  Future<void> _loadStats() async {
    LoggerService.d('Loading ticket stats', tag: _tag);
    try {
      final barcodes = await sl<BarcodeRepository>().getAllBarcodes();
      if (mounted) {
        setState(() {
          _totalTickets = barcodes.length;
          _usedTickets = barcodes.where((b) => b.isUsed).length;
          _availableTickets = _totalTickets - _usedTickets;
        });
        LoggerService.d(
          'Stats loaded: total=$_totalTickets, used=$_usedTickets, available=$_availableTickets',
          tag: _tag,
        );
      }
    } catch (e) {
      LoggerService.e('Failed to load stats', error: e, tag: _tag);
    }
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
    ).then((_) => _loadStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 20.h),
              PrepStatsSection(
                totalTickets: _totalTickets,
                usedTickets: _usedTickets,
                availableTickets: _availableTickets,
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
      bottomSheet: PrepBottomButton(
        onPressed: () => _navigateToScanner(context),
      ),
    );
  }
}

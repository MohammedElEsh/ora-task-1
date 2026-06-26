import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../../data/repositories/barcode_repository.dart';
import '../manager/scanner_cubit.dart';
import '../widgets/event_info_card.dart';
import '../widgets/prep_action_button.dart';
import 'scanner_view.dart';

class EventPreparationView extends StatefulWidget {
  const EventPreparationView({super.key});

  @override
  State<EventPreparationView> createState() => _EventPreparationViewState();
}

class _EventPreparationViewState extends State<EventPreparationView>
    with WidgetsBindingObserver {
  int _totalTickets = 0;
  int _usedTickets = 0;
  int _availableTickets = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStats();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadStats();
    }
  }

  Future<void> _loadStats() async {
    try {
      final barcodes = await sl<BarcodeRepository>().getAllBarcodes();
      if (mounted) {
        setState(() {
          _totalTickets = barcodes.length;
          _usedTickets = barcodes.where((b) => b.isUsed).length;
          _availableTickets = _totalTickets - _usedTickets;
        });
      }
    } catch (_) {}
  }

  void _navigateToScanner(BuildContext context) {
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
        child: RefreshIndicator(
          onRefresh: _loadStats,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildEventInfo(),
                SizedBox(height: 20.h),
                _buildStatsSection(),
                SizedBox(height: 24.h),
                _buildQuickActions(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildBottomButton(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 26.r,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gate Scanner',
                style: AppTypography.semiBold20.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Ready to scan tickets',
                style: AppTypography.regular14.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.badgeOnlineBg,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: const BoxDecoration(
                  color: AppColors.badgeOnline,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Online',
                style: AppTypography.medium12.copyWith(
                  color: AppColors.badgeOnline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo() {
    return const EventInfoCard(
      eventName: 'Music Festival 2025',
      venue: 'Cairo International Stadium',
      date: 'Saturday, June 28, 2025',
      time: '8:00 PM',
      gateNumber: 'Gate 3',
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Statistics',
          style: AppTypography.semiBold16.copyWith(color: AppColors.grey900),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total',
                value: '$_totalTickets',
                icon: Icons.confirmation_number_rounded,
                color: AppColors.primary,
                bgColor: AppColors.primary10,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                title: 'Used',
                value: '$_usedTickets',
                icon: Icons.check_circle_rounded,
                color: AppColors.validGreen,
                bgColor: AppColors.success10,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                title: 'Available',
                value: '$_availableTickets',
                icon: Icons.event_available_rounded,
                color: AppColors.warning,
                bgColor: AppColors.warning10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.semiBold16.copyWith(color: AppColors.grey900),
        ),
        SizedBox(height: 12.h),
        _ActionCard(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Start Scanning',
          subtitle: 'Open camera to scan tickets',
          onTap: () => _navigateToScanner(context),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: PrepActionButton(
          label: 'Open Scanner',
          icon: Icons.qr_code_scanner_rounded,
          onPressed: () => _navigateToScanner(context),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: AppTypography.bold28.copyWith(color: AppColors.grey900),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTypography.regular12.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            const BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colors.white, size: 24.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.semiBold16.copyWith(
                      color: AppColors.grey900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTypography.regular12.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey300,
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}

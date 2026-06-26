import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../../data/models/barcode_model.dart';
import '../../data/repositories/barcode_repository.dart';
import '../widgets/test_qr_ticket_row.dart';

class TestQrView extends StatefulWidget {
  const TestQrView({super.key});

  @override
  State<TestQrView> createState() => _TestQrViewState();
}

class _TestQrViewState extends State<TestQrView> {
  final BarcodeRepository _repository = sl<BarcodeRepository>();
  List<BarcodeModel> _barcodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBarcodes();
  }

  Future<void> _loadBarcodes() async {
    setState(() => _isLoading = true);
    try {
      final data = await _repository.getAllBarcodes();
      if (mounted) {
        setState(() {
          _barcodes = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCount = _barcodes.where((b) => !b.isUsed).length;
    final usedCount = _barcodes.where((b) => b.isUsed).length;

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
          _buildHandle(),
          _buildHeader(availableCount, usedCount),
          SizedBox(height: 8.h),
          _buildStats(availableCount, usedCount),
          SizedBox(height: 8.h),
          Flexible(
            child: _isLoading
                ? SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : RefreshIndicator(
                    onRefresh: _loadBarcodes,
                    child: _buildTicketList(),
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
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
  }

  Widget _buildHeader(int available, int used) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Scanner',
            style: AppTypography.semiBold18.copyWith(color: AppColors.grey900),
          ),
          SizedBox(height: 6.h),
          Text(
            'Select a ticket to simulate scanning',
            style: AppTypography.regular14.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int available, int used) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _StatBadge(
              count: available,
              label: 'Available',
              color: AppColors.validGreen,
              bgColor: AppColors.validGreenBg,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _StatBadge(
              count: used,
              label: 'Used',
              color: AppColors.deniedRed,
              bgColor: AppColors.deniedRedBg,
            ),
          ),
          SizedBox(width: 12.w),
          const Expanded(
            child: _StatBadge(
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

  Widget _buildTicketList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _barcodes.length + 1,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        if (index == _barcodes.length) {
          return TestQrTicketRow(
            code: 'TKT-999',
            holderName: 'Test User',
            ticketType: 'Invalid',
            status: 'Not Found',
            onTap: () => Navigator.pop(context, 'TKT-999'),
          );
        }
        final b = _barcodes[index];
        return TestQrTicketRow(
          code: b.code,
          holderName: b.holderName,
          ticketType: b.ticketType,
          status: b.isUsed ? 'Used' : 'Available',
          onTap: () => Navigator.pop(context, b.code),
        );
      },
    );
  }
}

class _StatBadge extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatBadge({
    required this.count,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: AppTypography.semiBold14.copyWith(color: color),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: AppTypography.regular12.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

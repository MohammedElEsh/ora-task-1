import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../data/models/barcode_model.dart';
import '../../data/repositories/barcode_repository.dart';
import '../widgets/bottom_sheet_handle.dart';
import '../widgets/test_qr_header.dart';
import '../widgets/test_qr_stats.dart';
import '../widgets/test_qr_ticket_list.dart';

class TestQrView extends StatefulWidget {
  const TestQrView({super.key});

  @override
  State<TestQrView> createState() => _TestQrViewState();
}

class _TestQrViewState extends State<TestQrView> {
  static const _tag = 'TestQrView';
  final BarcodeRepository _repository = sl<BarcodeRepository>();
  List<BarcodeModel> _barcodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    LoggerService.i('TestQrView initialized', tag: _tag);
    _loadBarcodes();
  }

  Future<void> _loadBarcodes() async {
    LoggerService.d('Loading barcodes', tag: _tag);
    setState(() => _isLoading = true);
    try {
      final data = await _repository.getAllBarcodes();
      if (mounted) {
        setState(() {
          _barcodes = data;
          _isLoading = false;
        });
        LoggerService.d('Loaded ${data.length} barcodes', tag: _tag);
      }
    } catch (e) {
      LoggerService.e('Failed to load barcodes', error: e, tag: _tag);
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
          const BottomSheetHandle(),
          const TestQrHeader(),
          SizedBox(height: 8.h),
          TestQrStats(available: availableCount, used: usedCount),
          SizedBox(height: 8.h),
          Flexible(
            child: _isLoading
                ? SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : RefreshIndicator(
                    onRefresh: _loadBarcodes,
                    child: TestQrTicketList(barcodes: _barcodes),
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }
}

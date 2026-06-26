import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/barcode_model.dart';
import 'test_qr_ticket_row.dart';

class TestQrTicketList extends StatelessWidget {
  final List<BarcodeModel> barcodes;

  const TestQrTicketList({super.key, required this.barcodes});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: barcodes.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        if (index == barcodes.length) {
          return TestQrTicketRow(
            code: 'TKT-999',
            holderName: 'Test User',
            ticketType: 'Invalid',
            status: 'Not Found',
            onTap: () => Navigator.pop(context, 'TKT-999'),
          );
        }
        final b = barcodes[index];
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

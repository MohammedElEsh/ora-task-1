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
      // +1 to include the hardcoded invalid ticket at the end
      itemCount: barcodes.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        // Last item: hardcoded invalid barcode for testing not-found
        if (index == barcodes.length) {
          return TestQrTicketRow(
            code: 'TKT-999',
            holderName: 'Test User',
            ticketType: 'Invalid',
            status: 'Not Found',
            // Pop the sheet and return "TKT-999" to the scanner
            onTap: () => Navigator.pop(context, 'TKT-999'),
          );
        }
        // Regular barcode from the database
        final b = barcodes[index];
        return TestQrTicketRow(
          code: b.code,
          holderName: b.holderName,
          ticketType: b.ticketType,
          status: b.isUsed ? 'Used' : 'Available',
          // Pop the sheet and return the barcode's code
          onTap: () => Navigator.pop(context, b.code),
        );
      },
    );
  }
}

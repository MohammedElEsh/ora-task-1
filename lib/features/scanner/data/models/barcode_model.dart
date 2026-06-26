import 'package:equatable/equatable.dart';

class BarcodeModel extends Equatable {
  final int? id; // SQLite row ID (null before insert)
  final String code; // barcode string, e.g. "TKT-001"
  final String eventName; // which event this ticket is for
  final String holderName; // attendee name
  final String ticketType; // VIP / Standard / Speaker Pass / etc.
  final bool isUsed; // true = already scanned at the gate
  final DateTime? usedAt; // when it was scanned (null if unused)
  final DateTime createdAt; // when the record was created

  const BarcodeModel({
    this.id,
    required this.code,
    required this.eventName,
    this.holderName = '',
    this.ticketType = '',
    this.isUsed = false,
    this.usedAt,
    required this.createdAt,
  });

  /// Returns a copy with only `isUsed` and `usedAt` overridden.
  /// Used after scanning to mark a ticket as used without touching other fields.
  BarcodeModel copyWith({bool? isUsed, DateTime? usedAt}) => BarcodeModel(
    id: id,
    code: code,
    eventName: eventName,
    holderName: holderName,
    ticketType: ticketType,
    isUsed: isUsed ?? this.isUsed,
    usedAt: usedAt ?? this.usedAt,
    createdAt: createdAt,
  );

  factory BarcodeModel.fromMap(Map<String, dynamic> m) => BarcodeModel(
    id: m['id'] as int?,
    code: m['code'] as String,
    eventName: m['event_name'] as String,
    holderName: (m['holder_name'] as String?) ?? '',
    ticketType: (m['ticket_type'] as String?) ?? '',
    isUsed: (m['is_used'] as int) == 1,
    usedAt: m['used_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(m['used_at'] as int)
        : null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
  );

  @override
  List<Object?> get props => [
    id,
    code,
    eventName,
    holderName,
    ticketType,
    isUsed,
    usedAt,
    createdAt,
  ];
}

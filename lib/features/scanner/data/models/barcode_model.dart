import 'package:equatable/equatable.dart';

class BarcodeModel extends Equatable {
  final int? id;
  final String code;
  final String eventName;
  final String holderName;
  final String ticketType;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;

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

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'event_name': eventName,
    'holder_name': holderName,
    'ticket_type': ticketType,
    'is_used': isUsed ? 1 : 0,
    'used_at': usedAt?.millisecondsSinceEpoch,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory BarcodeModel.fromMap(Map<String, dynamic> m) => BarcodeModel(
    id: m['id'] as int?,
    code: m['code'] as String,
    eventName: m['event_name'] as String,
    holderName: (m['holder_name'] as String?) ?? '',
    ticketType: (m['ticket_type'] as String?) ?? '',
    isUsed: (m['is_used'] as int) == 1,
    usedAt: m['used_at'] != null ? DateTime.fromMillisecondsSinceEpoch(m['used_at'] as int) : null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
  );

  @override
  List<Object?> get props => [id, code, eventName, holderName, ticketType, isUsed, usedAt, createdAt];
}

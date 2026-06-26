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

  BarcodeModel copyWith({
    int? id,
    String? code,
    String? eventName,
    String? holderName,
    String? ticketType,
    bool? isUsed,
    DateTime? usedAt,
    DateTime? createdAt,
  }) {
    return BarcodeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      eventName: eventName ?? this.eventName,
      holderName: holderName ?? this.holderName,
      ticketType: ticketType ?? this.ticketType,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'event_name': eventName,
      'holder_name': holderName,
      'ticket_type': ticketType,
      'is_used': isUsed ? 1 : 0,
      'used_at': usedAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    return BarcodeModel(
      id: map['id'] as int?,
      code: map['code'] as String,
      eventName: map['event_name'] as String,
      holderName: (map['holder_name'] as String?) ?? '',
      ticketType: (map['ticket_type'] as String?) ?? '',
      isUsed: (map['is_used'] as int) == 1,
      usedAt: map['used_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['used_at'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  @override
  List<Object?> get props => [id, code, eventName, holderName, ticketType, isUsed, usedAt, createdAt];
}

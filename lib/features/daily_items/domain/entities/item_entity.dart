import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ItemType { binary, quantitative }

abstract class ItemEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final ItemType type;
  final int? target;
  final TimeOfDay? duration;
  final String? unit;

  const ItemEntity({
    this.duration,
    required this.id,
    required this.title,
    this.description,
    this.iconIndex = 0,
    required this.type,
    this.target,
    this.unit,
  });

  @override
  List<Object?> get props => [id, title, description, iconIndex, type, target];
}

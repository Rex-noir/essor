import 'package:equatable/equatable.dart';

enum ItemType { binary, quantitative }

abstract class ItemEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;

  const ItemEntity({
    required this.id,
    required this.title,
    this.description,
    this.iconIndex = 0,
  });

  @override
  List<Object?> get props => [id, title, description, iconIndex];
}

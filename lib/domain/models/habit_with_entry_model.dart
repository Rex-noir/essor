import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';

class HabitWithEntryModel {
  final HabitModel habit;
  final HabitEntryModel entry;

  const HabitWithEntryModel({required this.habit, required this.entry});
}

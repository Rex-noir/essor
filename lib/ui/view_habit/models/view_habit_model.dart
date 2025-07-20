import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';

class ViewHabitModel {
  final HabitModel habit;
  final HabitEntryModel? entry;

  const ViewHabitModel({required this.habit, required this.entry});

  ViewHabitModel copyWith({HabitModel? habit, HabitEntryModel? entry}) {
    return ViewHabitModel(
      habit: habit ?? this.habit,
      entry: entry ?? this.entry,
    );
  }
}

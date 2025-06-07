import 'package:mobile/features/daily_items/domain/entities/habit_entity.dart';
import 'package:mobile/features/daily_items/domain/repositories/habit_repository.dart';

class GetHabitsForDateUsecase {
  final HabitListRepository repository;

  GetHabitsForDateUsecase(this.repository);

  Future<List<HabitEntity>> call(DateTime date) {
    return repository.fetchHabitsForDate(date);
  }
}

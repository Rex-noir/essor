import 'package:mobile/features/habit_list/domain/entities/habit_entity.dart';
import 'package:mobile/features/habit_list/domain/repositories/habit_list_repository.dart';

class GetHabitsForDateUsecase {
  final HabitListRepository repository;

  GetHabitsForDateUsecase(this.repository);

  Future<List<HabitEntity>> call(DateTime date) {
    return repository.fetchHabitsForDate(date);
  }
}

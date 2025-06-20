import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';

class GetHabitsForDateUsecase {
  final HabitRepository repository;

  GetHabitsForDateUsecase(this.repository);

  Future<List<HabitModel>> call(DateTime date) {
    return repository.fetchHabitsForDate(date);
  }
}

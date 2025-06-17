import 'package:mobile/data/dtos/habit_dto.dart';
import 'package:mobile/domain/datasources/habit_datasource.dart';
import 'package:mobile/domain/entities/habit_entity.dart';
import 'package:mobile/domain/entities/item_entity.dart';

class HabitLocalDataSource extends HabitDataSource {
  @override
  Future<List<HabitDto>> fetchHabitsForDate(DateTime date) {
    final sampleHabits = <HabitDto>[
      HabitDto(
        id: '1',
        title: 'Morning Run',
        description: 'Run every day',
        frequency: ItemFrequency.daily,
        startDate: DateTime(2025, 6, 1),
        interval: 1,
        isActive: true,
        iconIndex: 0, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '2',
        title: 'Meditate',
        description: 'Meditate every 2 days',
        frequency: ItemFrequency.daily,
        startDate: DateTime(2025, 6, 1),
        interval: 2,
        isActive: true,
        iconIndex: 1, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '3',
        title: 'Drink Water',
        description: 'Drink water every 3 days',
        frequency: ItemFrequency.daily,
        startDate: DateTime(2025, 6, 1),
        interval: 3,
        isActive: true,
        iconIndex: 2, // Added
        habitType: ItemType.quantitative, // Example
        targetValue: 8, // Example: 8 glasses of water
      ),
      HabitDto(
        id: '4',
        title: 'Yoga',
        description: 'Yoga on Mondays and Fridays',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [1, 5],
        interval: 1,
        isActive: true,
        iconIndex: 3, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '5',
        title: 'Journal',
        description: 'Journal on Tuesdays and Thursdays',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [2, 4],
        interval: 1,
        isActive: true,
        iconIndex: 4, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '6',
        title: 'Call Family',
        description: 'Call family every 2 weeks on Sunday',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [7],
        interval: 2,
        isActive: true,
        iconIndex: 5, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '7',
        title: 'Pay Credit Card',
        description: 'Pay on the 5th and 20th of each month',
        frequency: ItemFrequency.monthly,
        startDate: DateTime(2025, 6, 1),
        monthlyDates: [5, 20],
        interval: 1,
        isActive: true,
        iconIndex: 6, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '8',
        title: 'Clean House',
        description: 'Clean on the 1st and 15th every month',
        frequency: ItemFrequency.monthly,
        startDate: DateTime(2025, 6, 1),
        monthlyDates: [1, 15],
        interval: 1,
        isActive: true,
        iconIndex: 7, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '9',
        title: 'Read Book',
        description: 'Read every 3 days',
        frequency: ItemFrequency.daily,
        startDate: DateTime(2025, 6, 1),
        interval: 3,
        isActive: true,
        iconIndex: 8, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '10',
        title: 'Gardening',
        description: 'Gardening on Saturdays',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [6],
        interval: 1,
        isActive: true,
        iconIndex: 9, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '11',
        title: 'Grocery Shopping',
        description: 'Every 2 weeks on Thursday',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [4],
        interval: 2,
        isActive: true,
        iconIndex: 10, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '12',
        title: 'Exercise',
        description: 'Exercise on Mondays, Wednesdays, and Fridays',
        frequency: ItemFrequency.weekly,
        startDate: DateTime(2025, 6, 1),
        weeklyDays: [1, 3, 5],
        interval: 1,
        isActive: true,
        iconIndex: 11, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '13',
        title: 'Meal Prep',
        description: 'Prepare meals every 3 days',
        frequency: ItemFrequency.daily,
        startDate: DateTime(2025, 6, 1),
        interval: 3,
        isActive: true,
        iconIndex: 12, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '14',
        title: 'Monthly Report',
        description: 'Submit report on 10th each month',
        frequency: ItemFrequency.monthly,
        startDate: DateTime(2025, 6, 1),
        monthlyDates: [10],
        interval: 1,
        isActive: true,
        iconIndex: 13, // Added
        habitType: ItemType.binary, // Added
      ),
      HabitDto(
        id: '15',
        title: 'Plan Vacation',
        description: 'Plan on the last day of every month',
        frequency: ItemFrequency.monthly,
        startDate: DateTime(2025, 6, 1),
        monthlyDates: [30, 31], // For months with 30 or 31 days
        interval: 1,
        isActive: true,
        iconIndex: 14, // Added
        habitType: ItemType.binary, // Added
      ),
    ];
    return Future.value(sampleHabits);
  }
}

part of 'view_habit_bloc.dart';

sealed class ViewHabitState extends Equatable {
  const ViewHabitState();
}

final class ViewHabitInitial extends ViewHabitState {
  @override
  List<Object> get props => [];
}

final class ViewHabitLoaded extends ViewHabitState {
  final ViewHabitModel model;
  final DateTime date;

  const ViewHabitLoaded(this.model, this.date);

  @override
  List<Object?> get props => [model, date];

  ViewHabitLoaded copyWith({ViewHabitModel? model, DateTime? date}) {
    return ViewHabitLoaded(model ?? this.model, date ?? this.date);
  }
}

final class ViewHabitError extends ViewHabitState {
  final String message;

  const ViewHabitError(this.message);

  @override
  List<Object?> get props => [message];
}

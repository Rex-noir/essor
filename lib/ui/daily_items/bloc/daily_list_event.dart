part of 'daily_list_bloc.dart';

sealed class DailyListEvent extends Equatable {
  const DailyListEvent();

  @override
  List<Object?> get props => [];
}

final class DailyListDateChanged extends DailyListEvent {
  final int newIndex;
  const DailyListDateChanged(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}

class DailyListInitialize extends DailyListEvent {}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/utils/app_logger.dart';
import 'package:uuid/v4.dart';

part 'habit_form_event.dart';
part 'habit_form_state.dart';

class HabitFormBloc extends Bloc<HabitFormEvent, HabitFormState> {
  final logger = TaggedLogger("HabitFormBloc");
  final HabitRepository _repository;

  HabitFormBloc(this._repository) : super(HabitFormState.empty()) {
    on<HabitFormInitial>((event, emit) {
      final habit = event.habit;
      emit(
        state.copyWith(
          id: habit?.id ?? UuidV4().generate(),
          title: habit?.title ?? '',
          description: habit?.description ?? '',
          startTime: habit?.startTime,
          iconIndex: habit?.iconIndex ?? 0,
          frequency: habit?.frequency,
          startDate: habit?.startDate ?? event.startDate,
          weeklyDays: habit?.weeklyDays ?? const [],
          monthlyDates: habit?.monthlyDates ?? const [],
          interval: habit?.interval ?? 4,
          isActive: habit?.isActive ?? true,
          habitType: habit?.habitType,
          targetUnit: habit?.targetUnit,
          targetValue: habit?.targetValue,
          targetOperator: habit?.targetOperator,
          mode: habit != null ? HabitFormMode.edit : HabitFormMode.create,
        ),
      );
    });

    on<HabitFormTitleUpdated>(
      (event, emit) => emit(state.copyWith(title: event.title)),
    );

    on<HabitFormStartTimeUpdated>(
      (event, emit) => emit(state.copyWith(startTime: event.time)),
    );

    on<HabitFormDescriptionUpdated>(
      (event, emit) => emit(state.copyWith(description: event.description)),
    );

    on<HabitFormIconIndexUpdated>(
      (event, emit) => emit(state.copyWith(iconIndex: event.iconIndex)),
    );

    on<HabitFormFrequencyUpdated>(
      (event, emit) => emit(state.copyWith(frequency: event.frequency)),
    );

    on<HabitFormStartDateUpdated>(
      (event, emit) => emit(state.copyWith(startDate: event.startDate)),
    );

    on<HabitFormWeeklyDaysUpdated>(
      (event, emit) => emit(state.copyWith(weeklyDays: event.weeklyDays)),
    );

    on<HabitFormMonthlyDatesUpdated>(
      (event, emit) => emit(state.copyWith(monthlyDates: event.monthlyDates)),
    );

    on<HabitFormIntervalUpdated>(
      (event, emit) => emit(state.copyWith(interval: event.interval)),
    );

    on<HabitFormIsActiveToggled>(
      (event, emit) => emit(state.copyWith(isActive: event.isActive)),
    );

    on<HabitFormTypeUpdated>(
      (event, emit) => emit(state.copyWith(habitType: event.habitType)),
    );

    on<HabitFormTargetUnitUpdated>(
      (event, emit) => emit(state.copyWith(targetUnit: event.targetUnit)),
    );

    on<HabitFormTargetValueUpdated>(
      (event, emit) => emit(state.copyWith(targetValue: event.targetValue)),
    );

    on<HabitFormTargetOperatorUpdated>(
      (event, emit) =>
          emit(state.copyWith(targetOperator: event.targetOperator)),
    );

    on<HabitFormSubmitted>((event, emit) {
      if (state.mode == HabitFormMode.edit) {
        // TODO : Update the habit
        _repository.updateHabit(event.habit);
      } else {
        // TODO : create the habit
        _repository.createHabit(event.habit);
      }
    });
  }
}

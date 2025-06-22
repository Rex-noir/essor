import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/utils/app_logger.dart';
import 'package:uuid/v4.dart';

part 'new_routine_event.dart';
part 'new_routine_state.dart';

class NewRoutineBloc extends Bloc<NewRoutineEvent, NewRoutineState> {
  final CreateNewRoutineUsecase createNewRoutineUsecase;
  final TaggedLogger logger = TaggedLogger("NewRoutineBloc");

  NewRoutineBloc({required this.createNewRoutineUsecase})
    : super(NewRoutineState.initial()) {
    on<ChangeFrequencyNewRoutineEvent>(_onChangeFrequency);
    on<UpdateIntervalNewRoutineEvent>(_onUpdateInterval);
    on<UpdateWeeklyDaysNewRoutineEvent>(_onUpdateWeekyDays);
    on<UpdateMonthlyDatesNewRoutineEvent>(_onMonthlyDates);
    on<UpdateStartDateNewRoutineEvent>(_onUpdateStartDate);
    on<UpdateStartTimeNewRoutineEvent>(_onStartTimeUpdate);
    on<NewRoutineTitleChanged>(_onTitleChanged);
    on<NewRoutineIconChanged>(_onIconChanged);
    on<CreateRoutineRequested>(_onCreateRoutineRequested);
  }

  FutureOr<void> _onChangeFrequency(
    ChangeFrequencyNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(selectedFrequency: event.frequency));
  }

  void _onIconChanged(
    NewRoutineIconChanged event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(iconIndex: event.iconIndex));
  }

  Future<void> _onCreateRoutineRequested(
    CreateRoutineRequested event,
    Emitter<NewRoutineState> emit,
  ) async {
    final title = state.title.trim();
    final routine = RoutineModel(
      id: const UuidV4().generate(),
      title: title,
      startDate: state.startDate.dateOnly,
      startTime: state.startTime,
      frequency: state.selectedFrequency,
      weeklyDays: state.weeklyDays,
      monthlyDates: state.monthlyDates,
      interval: state.interval,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
      iconIndex: state.iconIndex,
      isShared: false,
      syncVersion: 1,
    );
    await createNewRoutineUsecase.call(routine);
    event.dailyListBloc.add(
      DailyListRefreshRequested(date: state.startDate.dateOnly),
    );
    final routineDate =
        (event.dailyListBloc.state as DailyListLoaded).selectedDate;
    event.navigateToViewRoutine(routine, routineDate);
  }

  void _onTitleChanged(
    NewRoutineTitleChanged event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  FutureOr<void> _onUpdateInterval(
    UpdateIntervalNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(interval: event.interval));
  }

  FutureOr<void> _onUpdateWeekyDays(
    UpdateWeeklyDaysNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(weeklyDays: event.weeklyDays));
  }

  FutureOr<void> _onMonthlyDates(
    UpdateMonthlyDatesNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(monthlyDates: event.monthlyDates));
  }

  FutureOr<void> _onUpdateStartDate(
    UpdateStartDateNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(startDate: event.startDate));
  }

  FutureOr<void> _onStartTimeUpdate(
    UpdateStartTimeNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(startTime: event.startTime));
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:uuid/v4.dart';

part 'routine_form_event.dart';
part 'routine_form_state.dart';

class RoutineFormBloc extends Bloc<RoutineFormEvent, RoutineFormState> {
  final CreateNewRoutineUsecase _createNewRoutineUsecase;
  final RoutineModel? existingRoutine;

  RoutineFormBloc({
    required CreateNewRoutineUsecase createNewRoutineUsecase, // <-- FIXED
    required this.existingRoutine,
  }) : _createNewRoutineUsecase = createNewRoutineUsecase,
       super(
         existingRoutine != null
             ? RoutineFormState(
                 title: existingRoutine.title,
                 iconIndex: existingRoutine.iconIndex,
                 selectedFrequency: existingRoutine.frequency,
                 startTime: existingRoutine.startTime,
                 interval: existingRoutine.interval,
                 weeklyDays: existingRoutine.weeklyDays,
                 monthlyDates: existingRoutine.monthlyDates,
                 startDate: existingRoutine.startDate,
               )
             : RoutineFormState.initial(),
       ) {
    on<RoutineFormFrequencyUpated>(_onChangeFrequency);
    on<RoutineFormIntervalUpdated>(_onUpdateInterval);
    on<RoutineFormWeeklyDaysUpdated>(_onUpdateWeekyDays);
    on<RoutineFormMonthlyDatesUpdated>(_onMonthlyDates);
    on<RoutineFormStartDateUpdated>(_onUpdateStartDate);
    on<RoutineFormStartTimeUpdated>(_onStartTimeUpdate);
    on<RoutineFormTitileUpdated>(_onTitleChanged);
    on<RoutineFormIconUpdated>(_onIconChanged);
    on<RoutineFormSubmitRequested>(_onRoutineSubmitRequested);
  }
  FutureOr<void> _onChangeFrequency(
    RoutineFormFrequencyUpated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(selectedFrequency: event.frequency));
  }

  void _onIconChanged(
    RoutineFormIconUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(iconIndex: event.iconIndex));
  }

  Future<void> _onRoutineSubmitRequested(
    RoutineFormSubmitRequested event,
    Emitter<RoutineFormState> emit,
  ) async {
    final title = state.title.trim();
    final routine = RoutineModel(
      id: existingRoutine?.id ?? const UuidV4().generate(),
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

    if (existingRoutine == null) {
      await _createNewRoutineUsecase.call(routine);
    }
    event.onSubmit(routine: routine);
  }

  void _onTitleChanged(
    RoutineFormTitileUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  FutureOr<void> _onUpdateInterval(
    RoutineFormIntervalUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(interval: event.interval));
  }

  FutureOr<void> _onUpdateWeekyDays(
    RoutineFormWeeklyDaysUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(weeklyDays: event.weeklyDays));
  }

  FutureOr<void> _onMonthlyDates(
    RoutineFormMonthlyDatesUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(monthlyDates: event.monthlyDates));
  }

  FutureOr<void> _onUpdateStartDate(
    RoutineFormStartDateUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(startDate: event.startDate));
  }

  FutureOr<void> _onStartTimeUpdate(
    RoutineFormStartTimeUpdated event,
    Emitter<RoutineFormState> emit,
  ) {
    emit(state.copyWith(startTime: event.startTime));
  }
}

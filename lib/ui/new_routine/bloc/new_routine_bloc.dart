import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/entities/habit_entity.dart';

part 'new_routine_event.dart';
part 'new_routine_state.dart';

class NewRoutineBloc extends Bloc<NewRoutineEvent, NewRoutineState> {
  NewRoutineBloc() : super(NewRoutineState.initial()) {
    on<ChangeFrequencyNewRoutineEvent>(_onChangeFrequency);
    on<UpdateIntervalNewRoutineEvent>(_onUpdateInterval);
    on<UpdateWeeklyDaysNewRoutineEvent>(_onUpdateWeekyDays);
    on<UpdateMonthlyDatesNewRoutineEvent>(_onMonthlyDates);
    on<UpdateStartDateNewRoutineEvent>(_onUpdateStartDate);
    on<UpdateStartTimeNewRoutineEvent>(_onStartTimeUpdate);
  }

  FutureOr<void> _onChangeFrequency(
    ChangeFrequencyNewRoutineEvent event,
    Emitter<NewRoutineState> emit,
  ) {
    emit(state.copyWith(selectedFrequency: event.frequency));
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

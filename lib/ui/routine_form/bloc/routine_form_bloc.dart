import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/domain/enums/item_frequency.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:mobile/domain/usecases/update_routine_usecase.dart';
import 'package:mobile/utils/app_logger.dart';
import 'package:uuid/uuid.dart';

part 'routine_form_event.dart';
part 'routine_form_state.dart';

class RoutineFormBloc extends Bloc<RoutineFormEvent, RoutineFormState> {
  final CreateNewRoutineUsecase _createNewRoutineUsecase;
  final UpdateRoutineUsecase _updateRoutineUsecase;

  final logger = TaggedLogger("RoutineFormBloc");

  RoutineFormBloc({
    required CreateNewRoutineUsecase createNewRoutineUsecase,
    required UpdateRoutineUsecase updateRoutineUsecase,
  }) : _createNewRoutineUsecase = createNewRoutineUsecase,
       _updateRoutineUsecase = updateRoutineUsecase,
       super(RoutineFormState.empty()) {
    on<RoutineFormFrequencyUpated>(_onChangeFrequency);
    on<RoutineFormIntervalUpdated>(_onUpdateInterval);
    on<RoutineFormWeeklyDaysUpdated>(_onUpdateWeekyDays);
    on<RoutineFormMonthlyDatesUpdated>(_onMonthlyDates);
    on<RoutineFormStartDateUpdated>(_onUpdateStartDate);
    on<RoutineFormStartTimeUpdated>(_onStartTimeUpdate);
    on<RoutineFormTitileUpdated>(_onTitleChanged);
    on<RoutineFormIconUpdated>(_onIconChanged);
    on<RoutineFormSubmitRequested>(_onRoutineSubmitRequested);
    on<RoutineFormInitial>(_onInitialize);
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
      id: state.id ?? const Uuid().v4(),
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

    logger.debug("MOde : ${state.mode}");
    if (state.mode == RoutineFormMode.create) {
      logger.debug("Creating routine");
      await _createNewRoutineUsecase(routine);
    } else if (state.mode == RoutineFormMode.edit) {
      logger.debug("Updating routine");
      await _updateRoutineUsecase(routine);
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

  FutureOr<void> _onInitialize(
    RoutineFormInitial event,
    Emitter<RoutineFormState> emit,
  ) {
    final routine = event.existingModel;
    if (routine != null) {
      emit(
        state.copyWith(
          id: routine.id,
          title: routine.title,
          iconIndex: routine.iconIndex,
          selectedFrequency: routine.frequency,
          startTime: routine.startTime,
          interval: routine.interval,
          weeklyDays: routine.weeklyDays,
          monthlyDates: routine.monthlyDates,
          startDate: routine.startDate,
          mode: RoutineFormMode.edit,
        ),
      );
    } else {
      emit(state.copyWith(mode: RoutineFormMode.create));
    }

    logger.debug("Mode after emitting ${state.mode}");
  }
}

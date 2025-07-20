import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/ui/view_habit/models/view_habit_model.dart';
import 'package:mobile/utils/app_logger.dart';

part 'view_habit_event.dart';
part 'view_habit_state.dart';

class ViewHabitBloc extends Bloc<ViewHabitEvent, ViewHabitState> {
  final HabitRepository _habitRepository;
  final logger = TaggedLogger("ViewHabitBloc");

  ViewHabitBloc(HabitRepository repository)
    : _habitRepository = repository,
      super(ViewHabitInitial()) {
    on<ViewHabitStarted>(_onViewHabitStarted);
    on<ViewHabitEntryUpdated>(_onViewHabitEntryUpdated);
  }

  FutureOr<void> _onViewHabitStarted(
    ViewHabitStarted event,
    Emitter<ViewHabitState> emit,
  ) {
    emit(ViewHabitLoaded(event.model, event.date));
  }

  Future<void> _onViewHabitEntryUpdated(
    ViewHabitEntryUpdated event,
    Emitter<ViewHabitState> emit,
  ) async {
    if (state is! ViewHabitLoaded) return;

    final currentState = state as ViewHabitLoaded;
    final newModel = currentState.model.copyWith(entry: event.entry);
    try {
      await _habitRepository.upsertEntry(event.entry);
      emit(currentState.copyWith(model: newModel));
    } catch (e) {
      logger.error('Error on entry update', e);
      emit(ViewHabitError(e.toString()));
    }
  }
}

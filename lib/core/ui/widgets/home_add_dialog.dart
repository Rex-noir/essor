import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/ui/widgets/home_add_dialog_action.dart';
import 'package:mobile/domain/repositories/habit_repository.dart';
import 'package:mobile/domain/repositories/routine_repository.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:mobile/domain/usecases/update_routine_usecase.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';
import 'package:mobile/ui/habit_form/screen/habit_form_screen.dart';
import 'package:mobile/ui/routine_form/bloc/routine_form_bloc.dart';
import 'package:mobile/ui/routine_form/screens/routine_form_screen.dart';
import 'package:mobile/utils/app_logger.dart';

class HomeAddDialog extends StatelessWidget {
  HomeAddDialog({super.key, required AnimationController rotationController})
    : _rotationController = rotationController;

  final AnimationController _rotationController;
  final logger = TaggedLogger("HomeAddDialog");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Stack(
        children: [
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeAddDialogAction(
                  title: "New Habit",
                  subtitle: "You can do it!",
                  icon: Icons.add,
                  backgroundColor: Colors.blue.shade50,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) =>
                              HabitFormBloc(context.read<HabitRepository>())
                                ..add(HabitFormInitial(null)),
                          child: const HabitFormScreen(),
                        ),
                      ),
                    );
                  },
                ),
                HomeAddDialogAction(
                  title: "New Routine",
                  subtitle: "Stay consistent!",
                  icon: Icons.add,
                  backgroundColor: Colors.green.shade50,
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => RoutineFormBloc(
                            createNewRoutineUsecase: CreateNewRoutineUsecase(
                              context.read<RoutineRepository>(),
                            ),
                            updateRoutineUsecase: UpdateRoutineUsecase(
                              context.read<RoutineRepository>(),
                            ),
                          )..add(RoutineFormInitial(null)),
                          child: RoutineFormScreen(),
                        ),
                      ),
                    ).whenComplete(() {
                      _rotationController.reverse();
                    });
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 - 36,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                _rotationController.reverse(); // Reverse animation
              },
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 0.7854,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.close,
                    size: 36,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

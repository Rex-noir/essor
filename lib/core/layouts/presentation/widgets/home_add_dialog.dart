import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/layouts/presentation/widgets/home_add_dialog_action.dart';
import 'package:mobile/data/repositories/routine_repository_impl.dart';
import 'package:mobile/database/daos/routines_dao.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/domain/usecases/create_new_routine_usecase.dart';
import 'package:mobile/ui/daily_items/bloc/daily_list_bloc.dart';
import 'package:mobile/ui/new_routine/bloc/new_routine_bloc.dart';
import 'package:mobile/ui/new_routine/screens/new_routine_screen.dart';
import 'package:mobile/utils/app_logger.dart';

class HomeAddDialog extends StatelessWidget {
  HomeAddDialog({
    super.key,
    required AnimationController rotationController,
    required ValueNotifier<bool> isSheetOpen,
  }) : _rotationController = rotationController,
       _isSheetOpen = isSheetOpen;

  final AnimationController _rotationController;
  final ValueNotifier<bool> _isSheetOpen;
  final logger = TaggedLogger("HomeAddDialog");

  @override
  Widget build(BuildContext context) {
    final appDatabase = context.read<AppDatabase>();
    final bloc = context.read<DailyListBloc>();
    logger.info("Building HomeAddDialog, ${bloc.toString()}");
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
                    // Todo
                  },
                ),
                HomeAddDialogAction(
                  title: "New Routine",
                  subtitle: "Stay consistent!",
                  icon: Icons.add,
                  backgroundColor: Colors.green.shade50,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => NewRoutineBloc(
                            createNewRoutineUsecase: CreateNewRoutineUsecase(
                              RoutineRepositoryImpl(RoutinesDao(appDatabase)),
                            ),
                          ),
                          child: const NewRoutineScreen(),
                        ),
                      ),
                    );
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
                _isSheetOpen.value = false;
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

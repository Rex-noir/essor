import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/extensions/date_extensions.dart';
import 'package:mobile/core/extensions/platform_extensions.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/infrastructure/notification/blocs/notification_bloc.dart';
import 'package:mobile/ui/habit_form/bloc/habit_form_bloc.dart';
import 'package:mobile/ui/habit_form/screen/habit_form_first_page.dart';
import 'package:mobile/ui/habit_form/screen/habit_form_second_page.dart';

class HabitFormScreen extends StatefulWidget {
  const HabitFormScreen({super.key});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2; // Adjust this based on your number of steps

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  String get _currentPageTitle {
    final formMode = context.read<HabitFormBloc>().state.mode;
    switch (_currentPage) {
      case 0:
        if (formMode == HabitFormMode.edit) {
          return "Edit Habit";
        }
        return "New Habit";
      case 1:
        return "Habit Details";
      default:
        return "New Habit";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    return BlocBuilder<HabitFormBloc, HabitFormState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              _currentPageTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withAlpha(76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: List.generate(_totalPages, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < _totalPages - 1 ? 8 : 0,
                        ),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // PageView content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: state.title.trim().isEmpty
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: [
                    HabitFormFirstPage(
                      context: context,
                      state: state,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    HabitFormSecondPage(
                      context: context,
                      state: state,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
              // Bottom navigation buttons
              if (!isKeyboardVisible)
                _buildBottomButtons(context, state, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    HabitFormState state,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back/Cancel button
          Expanded(
            child: OutlinedButton(
              onPressed: _currentPage == 0
                  ? () => Navigator.of(context).pop()
                  : _previousPage,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: .3),
                ),
              ),
              child: Text(
                _currentPage == 0 ? "Cancel" : "Back",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: .7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next/Create button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _getNextButtonEnabled(state)
                  ? () => _handleNextButtonPress(context, state)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                _getNextButtonText(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _getNextButtonEnabled(HabitFormState state) {
    if (_currentPage == 0) {
      // First page: require title to be filled
      return state.title.trim().isNotEmpty;
    } else {
      // Last page: enable if all required fields are filled
      return state.title.trim().isNotEmpty;
      // Add more validation conditions as needed
    }
  }

  String _getNextButtonText() {
    return _currentPage == _totalPages - 1 ? "Create Habit" : "Next Step";
  }

  void _handleNextButtonPress(BuildContext context, HabitFormState state) {
    if (_currentPage == _totalPages - 1) {
      // Final page - create the habit
      _createHabit(context, state);
    } else {
      // Not final page - go to next step
      _nextPage();
    }
  }

  void _createHabit(BuildContext context, HabitFormState state) {
    final habit = HabitModel(
      id: state.id,
      title: state.title,
      description: state.description,
      iconIndex: state.iconIndex,
      habitType: state.habitType,
      frequency: state.frequency,
      createdAt: DateTime.now(),
      deletedAt: null,
      interval: state.interval,
      isActive: state.isActive,
      weeklyDays: state.weeklyDays,
      monthlyDates: state.monthlyDates,
      startDate: state.startDate.dateOnly,
      startTime: state.startTime,
      lastScheduledAt: state.lastScheduledAt,
      targetUnit: state.targetUnit,
      targetValue: state.targetValue,
      targetOperator: state.targetOperator,
      updatedAt: DateTime.now(),
    );
    context.read<HabitFormBloc>().add(HabitFormSubmitted(habit));
    if (PlatformExtensions.isMobile) {
      context.read<NotificationBloc>().add(
        NotificationScheduleForHabitRequested(habit),
      );
    }
    Navigator.of(context).pop();
  }
}

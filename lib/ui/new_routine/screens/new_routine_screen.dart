import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/models/routine_model.dart';
import 'package:mobile/ui/new_routine/bloc/new_routine_bloc.dart';
import 'package:mobile/ui/new_routine/widgets/repeat_section_card.dart';
import 'package:mobile/ui/view_routine/bloc/view_routine_bloc.dart';
import 'package:mobile/ui/view_routine/screens/view_routine_screen.dart';
import 'package:uuid/v4.dart';

class NewRoutineScreen extends StatefulWidget {
  const NewRoutineScreen({super.key});

  @override
  State<NewRoutineScreen> createState() => _NewRoutineScreenState();
}

class _NewRoutineScreenState extends State<NewRoutineScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildTitleInput(context, theme),
                const SizedBox(height: 32),
                RepeatSectionCard(),
                const SizedBox(height: 24),
                _buildTimeOfDayPicker(context),
                const SizedBox(height: 24),
                _buildActionButtons(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        "New Routine",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: colorScheme.onSurface),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          "Build consistent habits that stick",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInput(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: 'Enter routine name...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Icon(
            Icons.edit_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
        autofocus: false,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _titleController,
            builder: (context, value, _) {
              final isValid = value.text.trim().isNotEmpty;

              return ElevatedButton(
                onPressed: isValid
                    ? () {
                        final bloc = context.read<NewRoutineBloc>();
                        final title = _titleController.text.trim();

                        final routine = RoutineModel(
                          id: UuidV4().generate(),
                          title: title,
                          startDate: bloc.state.startDate,
                          startTime: bloc.state.startTime,
                          frequency: bloc.state.selectedFrequency,
                          weeklyDays: bloc.state.weeklyDays,
                          monthlyDates: bloc.state.monthlyDates,
                          interval: bloc.state.interval,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          deletedAt: null,
                          iconIndex: 1,
                          isShared: false,
                          syncVersion: 1,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) =>
                                  ViewRoutineBloc()
                                    ..add(ViewRoutineStarted(routine, [])),
                              child: ViewRoutineScreen(),
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  "Create Routine",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeOfDayPicker(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          hoverColor: theme.colorScheme.primary.withOpacity(0.04),
          splashColor: theme.colorScheme.primary.withOpacity(0.08),
          onTap: () async {
            final bloc = context.read<NewRoutineBloc>();
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (picked != null) {
              bloc.add(UpdateStartTimeNewRoutineEvent(picked));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Time",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<NewRoutineBloc, NewRoutineState>(
                        buildWhen: (previous, current) =>
                            previous.startTime != current.startTime,
                        builder: (context, state) {
                          return Text(
                            state.startTime.format(context),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

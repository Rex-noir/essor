import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/enums/item_type.dart';
import 'package:mobile/domain/models/habit_entry_model.dart';
import 'package:mobile/domain/models/habit_model.dart';
import 'package:mobile/ui/view_habit/blocs/view_habit_bloc.dart';
import 'package:mobile/utils/item_util.dart';
import 'package:uuid/v4.dart';

class ViewHabitScreen extends StatefulWidget {
  const ViewHabitScreen({super.key});

  @override
  State<ViewHabitScreen> createState() => _ViewHabitScreenState();
}

class _ViewHabitScreenState extends State<ViewHabitScreen> {
  final TextEditingController _valueController = TextEditingController();

  bool _binaryValue = true;
  bool _initialized = false;
  bool _isDisabled = true;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ViewHabitBloc, ViewHabitState>(
        builder: (context, state) {
          if (state is ViewHabitLoaded) {
            if (!_initialized) {
              _initializeControllers(state.model.entry);
              _initialized = true;
            }
            return _buildContent(context, state);
          } else if (state is ViewHabitError) {
            return _buildError(context, state.message);
          } else {
            return _buildLoading(context);
          }
        },
      ),
    );
  }

  void _initializeControllers(HabitEntryModel? entry) {
    if (entry != null) {
      if (entry.value == 0) {
        _binaryValue = false;
      } else {
        _binaryValue = true;
      }
      _valueController.text = entry.value.toString();
    } else {
      _binaryValue = true;
      _valueController.clear();
    }
  }

  Widget _buildContent(BuildContext context, ViewHabitLoaded state) {
    final theme = Theme.of(context);
    final habit = state.model.habit;
    final entry = state.model.entry;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit Title
          Text(
            habit.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          // Habit Description
          if (habit.description != null && habit.description!.isNotEmpty)
            Text(
              habit.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

          const SizedBox(height: 32),

          // Today's Entry Section
          Text(
            'Today\'s Entry',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Value Input
                if (habit.habitType == ItemType.quantitative) ...[
                  Text(
                    'Value${habit.targetUnit != null ? ' (${habit.targetUnit})' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Minus button with subtle background
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.remove, size: 20),
                          onPressed: () {
                            _adjustValueBy(-1, entry);
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            padding: EdgeInsets.all(10),
                            minimumSize: Size(40, 40),
                          ),
                        ),
                      ),

                      // Text field in the middle
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: _valueController,
                            textAlign: TextAlign.center,
                            onChanged: (text) =>
                                _updateButtonState(double.parse(text), entry),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter value',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Plus button with primary accent
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add, size: 20),
                          onPressed: () {
                            _adjustValueBy(1, entry);
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.all(10),
                            minimumSize: Size(40, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ] else if (habit.habitType == ItemType.binary) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mark as Done',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Switch(
                        value: _binaryValue,
                        onChanged: (val) {
                          setState(() {
                            _binaryValue = val;
                          });
                          final dblVal = val == true ? 1.00 : 0.00;
                          _updateButtonState(dblVal, entry);
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        _saveEntry(context, habit, state.date, entry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDisabled
                          ? theme.colorScheme.onSurface.withValues(alpha: .12)
                          : theme.colorScheme.primary,
                      foregroundColor: _isDisabled
                          ? theme.colorScheme.onSurface.withValues(alpha: .38)
                          : theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      entry != null ? 'Update Entry' : 'Save Entry',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Habit Info Section
          if (habit.targetUnit != null) ...[
            Text(
              'Habit Info',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                spacing: 18,
                children: [
                  if (habit.targetValue != null) ...[
                    _buildInfoRow(
                      context,
                      'Target',
                      '${habit.targetOperator.toString()} ${habit.targetValue}${habit.targetUnit ?? ''}',
                      Icons.flag_outlined,
                    ),
                    Divider(),
                  ],
                  _buildInfoRow(
                    context,
                    'Frequency',
                    getFrequencyIntervalLabel(habit.frequency, habit.interval),
                    Icons.repeat_outlined,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: CircularProgressIndicator(color: theme.colorScheme.primary),
    );
  }

  void _saveEntry(
    BuildContext context,
    HabitModel habit,
    DateTime date,
    HabitEntryModel? existingEntry,
  ) {
    if (_isDisabled) return;

    final value = habit.habitType == ItemType.binary
        ? _binaryValue == true
              ? 1.00
              : 0.00
        : double.parse(_valueController.text.toString());

    final entry =
        existingEntry?.copyWith(value: value) ??
        HabitEntryModel(
          id: UuidV4().generate(),
          habitId: habit.id,
          entryDate: date,
          value: value,
        );

    context.read<ViewHabitBloc>().add(ViewHabitEntryUpdated(entry));

    _updateButtonState(value, entry);
  }

  void _updateButtonState(double value, HabitEntryModel? entry) {
    final isChanged = entry != null && entry.value != value;

    setState(() {
      _isDisabled = !isChanged;
    });
  }

  void _adjustValueBy(double step, HabitEntryModel? entry) {
    final current = double.tryParse(_valueController.text.trim()) ?? 0.0;
    final newValue = current + step;
    _valueController.text = newValue.toStringAsFixed(2);
    _updateButtonState(newValue, entry);
  }
}

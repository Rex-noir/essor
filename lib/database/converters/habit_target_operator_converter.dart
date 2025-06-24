import 'package:drift/drift.dart';
import 'package:mobile/domain/enums/habit_target_operator_enum.dart';

class HabitTargetOperatorConverter
    extends TypeConverter<TargetOperator, String> {
      const HabitTargetOperatorConverter();
  @override
  TargetOperator fromSql(String fromDb) {
    return TargetOperator.fromSymbol(fromDb) ?? TargetOperator.equalTo;
  }

  @override
  String toSql(TargetOperator value) {
    return value.symbol;
  }
}

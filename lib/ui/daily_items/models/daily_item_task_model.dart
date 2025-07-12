import 'package:mobile/domain/models/task_model.dart';
import 'package:mobile/ui/daily_items/models/daily_item_model.dart';

class DailyItemModelTaskModel extends DailyItemModel {
  final TaskModel task;

  DailyItemModelTaskModel(this.task);
}

import 'package:intl/intl.dart';

class ModelParsers {
  static String dateTo(DateTime date) {
    final formatter = DateFormat("dd-MM-yyyy");
    return formatter.format(date);
  }
}

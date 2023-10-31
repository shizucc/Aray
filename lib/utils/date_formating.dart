import 'package:intl/intl.dart';

class DateFormating {
  static String createdAtFormat(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
    DateFormat timeFormat = DateFormat('HH.mm');
    String date = dateFormat.format(dateTime);
    String time = timeFormat.format(dateTime);
    return '$date at $time';
  }
}

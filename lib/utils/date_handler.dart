import 'package:intl/intl.dart';

class DateHandler {
  static String dateAndTimeFormat(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
    DateFormat timeFormat = DateFormat('HH.mm');
    String date = dateFormat.format(dateTime);
    String time = timeFormat.format(dateTime);
    return '$date at $time';
  }

  static String dateFormat(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'en_US');
    String date = dateFormat.format(dateTime);
    return date;
  }
}

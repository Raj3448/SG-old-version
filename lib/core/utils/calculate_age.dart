import 'package:easy_localization/easy_localization.dart';

int calculateAge(DateTime dob) {
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final formattedTime = DateFormat('h:mma').format(dateTime);

  if (date == today) {
    return 'Today at $formattedTime';
  } else {
    return '${DateFormat('MMM d, y').format(dateTime)} at $formattedTime';
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

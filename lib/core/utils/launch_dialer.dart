import 'package:url_launcher/url_launcher.dart';

Future<void> launchDialer(String phoneNumber) async {
    final telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw Exception('Could not launch $telUri');
    }
  }
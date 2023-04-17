import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneDialer(String contactNumber) async {
   Uri phoneUri = Uri(
      scheme: "tel",
      path: contactNumber
  );
  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  } catch (error) {
    throw("Cannot dial");
  }
}

Future<void> launchMessage(String message) async {
   Uri smsUri = Uri(
      scheme: "sms",
      path: message
  );
  try {
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  } catch (error) {
    throw("Cannot dial");
  }
}

Future<void> launchEmail(String email) async {
   Uri emailUri = Uri(
      scheme: "mailto",
      path: email
  );
  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  } catch (error) {
    throw("Cannot dial");
  }
}
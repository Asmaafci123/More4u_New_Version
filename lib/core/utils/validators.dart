import 'package:easy_localization/easy_localization.dart';
import 'package:more4u/core/constants/app_strings.dart';

String? validatePassword(String? value) {
  RegExp regex =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,32}$');
  if (value==null||value.isEmpty) {
    return AppStrings.pleaseEnterPassword.tr();
  } else {
    if (!regex.hasMatch(value)) {
      return AppStrings.infoAboutPassword.tr();
    } else {
      return null;
    }
  }
}
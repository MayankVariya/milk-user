import 'package:flutter/material.dart';
import 'package:milk_user/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const themeStatus = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.indigo,
      // primaryColor: Colors.green,
      // primaryColor: isDarkTheme ? Colors.black : Colors.white,
      // bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //   backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      // ),

      // iconButtonTheme: IconButtonThemeData(
      //     style: ButtonStyle(
      //         iconColor: MaterialStatePropertyAll(
      //   isDarkTheme ? Colors.white : Colors.black,
      // ))),

      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      // navigationBarTheme: NavigationBarThemeData(
      //     backgroundColor: isDarkTheme ? Colors.black : Colors.white),
      // backgroundColor: isDarkTheme ? Colors.black : Colors.white,

      // indicatorColor: isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      // // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      //
      // hintColor: isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
      //
      // highlightColor: isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
      // // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      //
      // focusColor: isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: isDarkTheme ? Colors.grey.shade900 : Colors.white),
      cardColor: isDarkTheme ? Colors.grey.shade900 : Colors.white,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: indigo700),

      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        backgroundColor: isDarkTheme ? Colors.grey.shade900 : Colors.white,
        titleTextStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

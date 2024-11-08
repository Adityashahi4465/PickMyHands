import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

final fontFamilyProvider = StateProvider<String>((ref) {
  return 'Poppins';
});

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  late SharedPreferences storage;
  final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: Colors.grey[600],
    brightness: Brightness.light,
    primaryColor: Lpurple1,
    scaffoldBackgroundColor: Lcream,
    textTheme: TextTheme(
      headlineLarge: const TextStyle().copyWith(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: const TextStyle().copyWith(
          fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.black),
      headlineSmall: const TextStyle().copyWith(
          fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black),
      titleLarge: const TextStyle(
          fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.black),
      titleMedium: const TextStyle().copyWith(
          fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black),
      titleSmall: const TextStyle().copyWith(
          fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.black),
      bodyLarge: const TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
      bodyMedium: const TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black),
      bodySmall: const TextStyle().copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.5)),
      labelLarge: const TextStyle().copyWith(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
      labelMedium: const TextStyle().copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: Colors.black.withOpacity(0.5)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Lpurple1,
      iconTheme: IconThemeData(color: Lcream),
      actionsIconTheme: IconThemeData(color: Lcream),
      titleTextStyle: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Lpurple1, // Background color
        foregroundColor: Lcream,
        padding: const EdgeInsets.all(8), // Text color
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        minimumSize: const Size(
            double.infinity, 60), // Setting the minimum size with height 60
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black87,
      textStyle: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    )),
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 3,
      // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),

      border: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Lpurple1),
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Lpurple1),
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Lpurple1),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        // borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2, color: Colors.black),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2, color: Colors.black),
      ),
    ),
  );
// inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

  final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: Ddisable,
    brightness: Brightness.dark,
    primaryColor: Dbrown1,
    textTheme: TextTheme(
      headlineLarge: const TextStyle().copyWith(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: const TextStyle().copyWith(
          fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: const TextStyle().copyWith(
          fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: const TextStyle(
          fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.white),
      titleMedium: const TextStyle().copyWith(
          fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white),
      titleSmall: const TextStyle().copyWith(
          fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.white),
      bodyLarge: const TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: const TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
      bodySmall: const TextStyle().copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.5)),
      labelLarge: const TextStyle().copyWith(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
      labelMedium: const TextStyle().copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.5)),
    ),
    scaffoldBackgroundColor: Dbrown2,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Dbrown1,
      iconTheme: IconThemeData(color: Dcream),
      actionsIconTheme: IconThemeData(color: Dcream),
      titleTextStyle: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900], // Background color
        foregroundColor: Dcream,
        padding: const EdgeInsets.all(8), // Text color
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        minimumSize: const Size(
            double.infinity, 60), // Setting the minimum size with height 60
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    )),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Lpurple1;
        } else {
          return Colors.transparent;
        }
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 3,
      // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),

      border: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Dcream),
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Dcream),
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2.0, color: Dcream),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        // borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2, color: Colors.white),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        borderSide: const BorderSide(width: 2, color: Colors.white),
      ),
    ),
  );

  /// Customizable Dark Text Theme

  changeTheme() {
    _isDark = !isDark;
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }
}

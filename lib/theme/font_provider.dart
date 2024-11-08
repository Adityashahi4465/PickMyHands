import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizes {
  final double fontSize;
  final double headingSize;
  final double subheadingSize;
  final double bodyLarge;
  FontSizes({
    required this.fontSize,
    required this.headingSize,
    required this.subheadingSize,
    required this.bodyLarge,
  });
}
final fontSizeManager = Provider<FontSizeManager>((ref){
  return FontSizeManager();
});
final fontSizesProvider = Provider<FontSizes>((ref) {
  return FontSizes(
    fontSize: ref.watch(fontSizeStateProvider),
    headingSize: ref.watch(headingFontSizeStateProvider),
    subheadingSize: ref.watch(subheadingFontSizeStateProvider),
    bodyLarge: ref.watch(bodyLargeFontSizeStateProvider),
  );
});

final fontSizeStateProvider = StateProvider<double>((ref) {
  return ref.read(sharedPreferencesProvider).getDouble('fontSize') ?? 16.0;
});

final headingFontSizeStateProvider = StateProvider<double>((ref) {
  return ref.read(sharedPreferencesProvider).getDouble('headingSize') ?? 24.0;
});

final subheadingFontSizeStateProvider = StateProvider<double>((ref) {
  return ref.read(sharedPreferencesProvider).getDouble('subheadingSize') ??
      18.0;
});

final bodyLargeFontSizeStateProvider = StateProvider<double>((ref) {
  return ref.read(sharedPreferencesProvider).getDouble('bodyLargeSize') ?? 22.0;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  return ref.read(sharedPreferencesFutureProvider).maybeWhen(
        data: (sharedPreferences) => sharedPreferences,
        orElse: () => throw Exception(
          "SharedPreferences is not available.",
        ),
      );
});

final sharedPreferencesFutureProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

class FontSizeManager {
  static Future<void> updateFontSize(double value, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<void> fetchFontSizesAndUpdateProviders(ProviderRef ref) async {
    final prefs = await SharedPreferences.getInstance();

    double fontSize = prefs.getDouble('fontSize') ?? 16.0;
    double headingSize = prefs.getDouble('headingSize') ?? 24.0;
    double subheadingSize = prefs.getDouble('subheadingSize') ?? 18.0;
    double bodyLargeSize = prefs.getDouble('bodyLargeSize') ?? 18.0;

    ref.read(fontSizeStateProvider.notifier).state = fontSize;
    ref.read(headingFontSizeStateProvider.notifier).state = headingSize;
    ref.read(subheadingFontSizeStateProvider.notifier).state = subheadingSize;
    ref.read(bodyLargeFontSizeStateProvider.notifier).state = bodyLargeSize;
  }

   Future<void> increaseAllFontSizes(WidgetRef ref) async {
    final fontSizeState = ref.read(fontSizeStateProvider.notifier);
    final headingFontSizeState =
        ref.read(headingFontSizeStateProvider.notifier);
    final subheadingFontSizeState =
        ref.read(subheadingFontSizeStateProvider.notifier);
    final bodyLargeFontSizeState =
        ref.read(bodyLargeFontSizeStateProvider.notifier);

    // Directly read from SharedPreferences before increasing
    double fontSize =
        ref.read(sharedPreferencesProvider).getDouble('fontSize') ?? 16.0;
    double headingSize =
        ref.read(sharedPreferencesProvider).getDouble('headingSize') ?? 24.0;
    double subheadingSize =
        ref.read(sharedPreferencesProvider).getDouble('subheadingSize') ?? 18.0;
    double bodyLargeSize =
        ref.read(sharedPreferencesProvider).getDouble('bodyLargeSize') ?? 18.0;

    // Apply constraints
    fontSizeState.state = (fontSize + 2.0).clamp(16.0, 30.0);
    headingFontSizeState.state = (headingSize + 2.0).clamp(18.0, 32.0);
    subheadingFontSizeState.state = (subheadingSize + 2.0).clamp(14.0, 28.0);
    bodyLargeFontSizeState.state = (bodyLargeSize + 2.0).clamp(14.0, 28.0);

    // Update SharedPreferences
    await updateFontSize(fontSizeState.state, 'fontSize');
    await updateFontSize(headingFontSizeState.state, 'headingSize');
    await updateFontSize(subheadingFontSizeState.state, 'subheadingSize');
    await updateFontSize(bodyLargeFontSizeState.state, 'bodyLargeSize');
  }

   Future<void> decreaseAllFontSizes(WidgetRef ref) async {
    final fontSizeState = ref.read(fontSizeStateProvider.notifier);
    final headingFontSizeState =
        ref.read(headingFontSizeStateProvider.notifier);
    final bodyLargeFontSizeState =
        ref.read(bodyLargeFontSizeStateProvider.notifier);
    final subheadingFontSizeState =
        ref.read(subheadingFontSizeStateProvider.notifier);

    // Directly read from SharedPreferences before decreasing
    double fontSize =
        ref.read(sharedPreferencesProvider).getDouble('fontSize') ?? 16.0;
    double headingSize =
        ref.read(sharedPreferencesProvider).getDouble('headingSize') ?? 24.0;
    double bodyLargeSize =
        ref.read(sharedPreferencesProvider).getDouble('bodyLargeSize') ?? 24.0;
    double subheadingSize =
        ref.read(sharedPreferencesProvider).getDouble('subheadingSize') ?? 18.0;

    // Apply constraints
    fontSizeState.state = (fontSize - 2.0).clamp(16.0, 30.0);
    headingFontSizeState.state = (headingSize - 2.0).clamp(18.0, 26.0);
    bodyLargeFontSizeState.state = (bodyLargeSize - 2.0).clamp(18.0, 32.0);
    subheadingFontSizeState.state = (subheadingSize - 2.0).clamp(14.0, 28.0);

    // Update SharedPreferences
    await updateFontSize(fontSizeState.state, 'fontSize');
    await updateFontSize(headingFontSizeState.state, 'headingSize');
    await updateFontSize(bodyLargeFontSizeState.state, 'bodyLargeSize');
    await updateFontSize(subheadingFontSizeState.state, 'subheadingSize');
  }
}

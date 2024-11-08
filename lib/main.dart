import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/error_text.dart';
import 'core/common/loader.dart';
import 'core/utils/notification_service.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/user/controller/user_controller.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'routes/routes.dart';
import 'theme/font_provider.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:timezone/data/latest.dart' as tz;

Future<void> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Prompt the user to enable location services
    bool isEnabled = await Geolocator.openLocationSettings();
    if (!isEnabled) {
      // Handle the case where the user didn't enable location service
      return;
    }
  }

  // Now that we've ensured location service is enabled, proceed with checking permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Request permission only if it's not granted
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied location permission
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Handle the case where the user permanently denied location permission
    return;
  }

  // Now that we have ensured location service is enabled and permission is granted, get the current position
  var position = await Geolocator.getCurrentPosition();
  print(position);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await determinePosition();

  final sharedPreferences = await SharedPreferences.getInstance();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getUserData(WidgetRef ref, User data) async {
    print('getData called');
    userModel = await ref
        .watch(userControllerProvider.notifier)
        .getUserDataById(id: data.uid.toString())
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return provider.ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider()..init(),
      child: provider.Consumer<ThemeProvider>(
          builder: (context, ThemeProvider notifier, child) {
        return ref.watch(authStateChangeProvider).when(
              data: (data) => MaterialApp.router(
                // if The data available means the user is logged in
                debugShowCheckedModeBanner: false,
                title: 'Sampoorna',
                theme: notifier.lightTheme, // Use lightTheme for light mode
                darkTheme: notifier.darkTheme, // Use darkTheme for dark mode
                themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
                routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) {
                    if (data != null) {
                      print('data != null ? : $data');
                      var userModel = ref.watch(userProvider);

                      if (userModel != null &&
                          ref
                              .read(authControllerProvider.notifier)
                              .isEmailVerified) {
                        print(
                            'userProvider.notifier: ${ref.read(userProvider.notifier)}');
                        return loggedInRoute;
                      } else if (userModel == null) {
                        getUserData(ref, data);
                      }
                    }
                    return loggedOutRoute;
                  },
                ),
                routeInformationParser: const RoutemasterParser(),
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
      }),
    );
  }
}

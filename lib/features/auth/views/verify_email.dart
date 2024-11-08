import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../controller/auth_controller.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void sandVerificationEmail() {
    ref.read(authControllerProvider.notifier).sendEmailVerification(
          context,
          ref.read(userProvider)!.email,
        );
  }

  setTimerForAutoRedirect() {
    ref.read(authControllerProvider.notifier).setTimerForAutoRedirect();
  }

  checkEmailVerification() {
    ref
        .read(authControllerProvider.notifier)
        .checkEmailVerificationStatus(context);
  }

  @override
  void initState() {
    sandVerificationEmail();
    setTimerForAutoRedirect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    final user = ref.watch(userProvider);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => logout(ref),
            icon: const Icon(
              Icons.clear,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Image(
                image: AssetImage(
                  "assets/images/onboardin1.png",
                ),
              ),
              Text("Verify your email address!",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              Text(user!.email ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              Text("Congratulations! Your Account Awaits: Verify Your Email",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    checkEmailVerification();
                  },
                  child: const Text("Continue"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius here
                        side: BorderSide(
                            color: isDarkTheme ? Dcream : Lpurple1,
                            width: 2.0), // Specify border color and width
                      ),
                    ),
                  ),
                  onPressed: () {
                    sandVerificationEmail();
                  },
                  child: const Text("Resend Email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../../../core/common/loader.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../controller/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  static const String id = "login_screen";

  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginView> {
  bool isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    print('login');
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = provider.Provider.of<ThemeProvider>(context).isDark;
    final loading = ref.watch(authControllerProvider);
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Switch(
                activeColor: Dcream,
                value: notifier.isDark,
                onChanged: (value) => notifier.changeTheme(),
              ),
            ), // Place the toggle button in the app bar
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        "Login to your account",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Welcome to Sampoorna",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 22,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text.rich(TextSpan(children: [
                                            TextSpan(
                                              text: 'Enter your Email ID',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                            ),
                                            TextSpan(
                                              text: ' (Required)',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ])),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        validator: (value) =>
                                            TValidator.validateEmail(value),
                                        keyboardType: TextInputType.name,
                                        textAlign: TextAlign.left,
                                        onChanged: (value) {
                                          //Do something with the user input.
                                          // name = value;
                                        },
                                        decoration: const InputDecoration(
                                          hintText:
                                              'enter your registered email id',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Enter Password',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: ' (Required)',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        validator: (value) =>
                                            TValidator.validateEmptyText(
                                                'Password', value),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: isPasswordVisible,
                                        textAlign: TextAlign.left,
                                        onChanged: (value) {
                                          //Do something with the user input.
                                          // password = value;
                                        },
                                        decoration: InputDecoration(
                                          suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isPasswordVisible =
                                                    !isPasswordVisible;
                                              });
                                            },
                                            child: isPasswordVisible
                                                ? Text(
                                                    'Show',
                                                    style: TextStyle(
                                                      color: isDarkTheme
                                                          ? Dcream
                                                          : Lpurple1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                : Text(
                                                    'Hide',
                                                    style: TextStyle(
                                                      color: isDarkTheme
                                                          ? Dcream
                                                          : Lpurple1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                          ),
                                          hintText: 'Enter the password',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigation.navigateToForGotPassword(
                                    context,
                                  ),
                                  child: Text(
                                    "Forgot Password?",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        loading
                            ? const Loader()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    login();
                                    // controller.emailAndPasswordSignIn();
                                    // Navigator.pushNamed(context, first.id);
                                  }, // Remove shadow if not needed
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 20, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0), // Adjust the border radius here
                                        side: BorderSide(
                                            color:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            width:
                                                2.0), // Specify border color and width
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigation.navigateToRegister(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Register Now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}

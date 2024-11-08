import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void forgotPassword() {
    if (formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).sendPasswordResetEmail(
            context,
            emailController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Forget password!",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            Text(
                "Don’t worry sometimes people can forget too, enter your email and we will send you a password reset link.",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: 'Enter Email ID',
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
                          validator: TValidator.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            hintText: 'eg. pragatigangwar@gmail.com',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const SizedBox()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        forgotPassword();
                      },
                      child: const Text("Submit"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

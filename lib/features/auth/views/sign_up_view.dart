import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:country_code_picker/country_code_picker.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils/validators.dart';
import '../../../theme/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../theme/theme_provider.dart';
import '../controller/auth_controller.dart';

class SignupView extends ConsumerStatefulWidget {
  static const String id = "signup";
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _signupState();
}

class _signupState extends ConsumerState<SignupView> {
  CountryCode countryCode = CountryCode(name: "IN", dialCode: '+91');
  String? gender;
  String? disability;
  bool isPasswordVisible = true;
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final date = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  void signup() {
    ref.read(authControllerProvider.notifier).registerWithEmailAndPassword(
          email: email.text,
          password: password.text,
          name: name.text,
          dob: date.text,
          phone: "$countryCode${phone.text}",
          context: context,
          disability: disability!,
          gender: gender!,
        );
  }

  @override
  void dispose() {
    email.dispose();
    name.dispose();
    password.dispose();
    phone.dispose();
    date.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final loading = ref.watch(authControllerProvider);
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Switch(
                  value: notifier.isDark,
                  onChanged: (value) => notifier.changeTheme()),
            ), // Place the toggle button in the app bar
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Fill your information below ",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 24,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: signupFormKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Enter your Full Name',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: name,
                                      validator: (value) =>
                                          TValidator.validateEmptyText(
                                              'Full Name', value),
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.left,
                                      onChanged: (value) {
                                        //Do something with the user input.
                                        // name = value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'eg. Pragati Gangwar',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
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
                                    TextFormField(
                                      validator: (value) =>
                                          TValidator.validateEmail(value),
                                      controller: email,
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.left,
                                      onChanged: (value) {
                                        //Do something with the user input.
                                        // name = value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'eg. pragatigangwar@gmail.com',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Enter Mobile No.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
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
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isDarkTheme
                                                  ? Dcream
                                                  : Lpurple1,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(32.0),
                                              bottomLeft: Radius.circular(32.0),
                                              topRight: Radius.circular(32.0),
                                              bottomRight:
                                                  Radius.circular(32.0),
                                            ),
                                          ),
                                          child: CountryCodePicker(
                                            textStyle: TextStyle(
                                              color: isDarkTheme
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                              fontSize: 18,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                            flagWidth: 35,
                                            onChanged: (value) {
                                              countryCode = value;
                                            },
                                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                            initialSelection: 'IN',
                                            favorite: const ['+91', 'IN'],
                                            // optional. Shows only country name and flag
                                            showCountryOnly: false,
                                            // optional. Shows only country name and flag when popup is closed.
                                            showOnlyCountryWhenClosed: false,
                                            // optional. aligns the flag and the Text left
                                            alignLeft: false,
                                            dialogBackgroundColor: isDarkTheme
                                                ? Colors.grey[800]
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) =>
                                                TValidator.validatePhoneNumber(
                                                    value),
                                            controller: phone,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.left,
                                            onChanged: (value) {
                                              //Do something with the user input.
                                              // phoneNumber = "$countryCode$value";
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'eg. 94********',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Select Gender',
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      height: 140,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isDarkTheme ? Dcream : Lpurple1,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(32.0),
                                          bottomLeft: Radius.circular(32.0),
                                          topRight: Radius.circular(32.0),
                                          bottomRight: Radius.circular(32.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            hoverColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text("Female",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Female",
                                            groupValue: gender,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            dense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text("Male",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Male",
                                            groupValue: gender,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text("Other",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Other",
                                            groupValue: gender,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ////////////////////////////// Disability///////////////////////////////
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Select Disability',
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      height: 240,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isDarkTheme ? Dcream : Lpurple1,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(32.0),
                                          bottomLeft: Radius.circular(32.0),
                                          topRight: Radius.circular(32.0),
                                          bottomRight: Radius.circular(32.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            hoverColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text(
                                                "Locomotor Disability",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Locomotor Disability",
                                            groupValue: disability,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            dense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                disability = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text("Blindness",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Blindness",
                                            groupValue: disability,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                disability = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text(
                                              "Low Vision",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            value: "Low Vision",
                                            groupValue: disability,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                disability = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title: const Text(
                                                "Intellectual Disability",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                            value: "Intellectual Disability",
                                            groupValue: disability,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                disability = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: -1.0,
                                                vertical: -1.0),
                                            // Add this line to remove the ripple effect
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            dense: true,
                                            activeColor:
                                                isDarkTheme ? Dcream : Lpurple1,
                                            title:
                                                const Text("Other Disability",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    )),
                                            value: "Other Disability",
                                            groupValue: disability,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0),
                                            onChanged: (value) {
                                              setState(() {
                                                disability = value.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Enter Password',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
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
                                      validator: (value) =>
                                          TValidator.validatePassword(value),
                                      controller: password,
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                )
                                              : Text(
                                                  'Hide',
                                                  style: TextStyle(
                                                    color: isDarkTheme
                                                        ? Dcream
                                                        : Lpurple1,
                                                    fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: 'Enter Date of Birth',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
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
                                      controller: date,
                                      validator: (value) =>
                                          TValidator.validateEmptyText(
                                              'Date', value),
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.none,
                                      // onChanged: (value) {
                                      //   //Do something with the user input.
                                      //   // password = value;
                                      // },
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.calendar_month_rounded,
                                          color:
                                              isDarkTheme ? Dcream : Lpurple1,
                                        ),
                                        hintText: 'Select date',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                      ),
                                      onTap: () async {
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime.now());
                                        if (pickeddate != null) {
                                          setState(() {
                                            date.text = DateFormat('dd-MM-yyyy')
                                                .format(pickeddate);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          loading
                              ? const Loader()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      bottom: 15,
                                      top: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (signupFormKey.currentState!
                                          .validate()) {
                                        signup();
                                      }
                                    },
                                    child: const Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              bottom: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you have already an account?",
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0), // Adjust the border radius here
                                          side: BorderSide(
                                              color: isDarkTheme
                                                  ? Dcream
                                                  : Lpurple1,
                                              width:
                                                  2.0), // Specify border color and width
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Navigator.pushNamed(context, signup().id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Text(
                                        "Login",
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
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

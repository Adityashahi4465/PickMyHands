// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../apis/auth_api.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/user_model.dart';
import '../../../routes/route_utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authAPI: ref.watch(authApiProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final Ref _ref;
  AuthController({required AuthAPI authAPI, required Ref ref})
      : _authAPI = authAPI,
        _ref = ref,
        super(false); // loading while asynchronous tasks initially false

  Stream<User?> get authStateChange => _authAPI.authStateChanges;

  Future<void> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String name,
      required String dob,
      required String phone,
      required BuildContext context,
      required String gender,
      required String disability}) async {
    final uid = const Uuid().v1();
    UserModel _userModel = UserModel(
      id: uid,
      name: name,
      email: email,
      phoneNumber: phone,
      dob: '',
      gender: gender,
      disability: disability,
      disabilityCerti: '',
      profilePicture: '',
    );
    state = true; // loading starts
    final res = await _authAPI.registerWithEmailAndPassword(
      userModel: _userModel,
      password: password,
    );
    state = false;
    res.fold((l) {
      print(l.message);
      showCustomSnackbar(context, l.message, _ref);
    }, (userModel) {
      Navigation.navigateToBack(context);
    });
  }

  bool get isEmailVerified {
    final user = _authAPI.currentUser;
    return user?.emailVerified ?? false;
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    print('login');

    final res = await _ref.read(authApiProvider).logIn(
          email: email,
          password: password,
        );
    state = false;
    res.fold(
      (l) {
        print(l.message);
        showCustomSnackbar(context, l.message, _ref);
      },
      (userModel) {
        if (isEmailVerified) {
          _ref.read(userProvider.notifier).update((state) => userModel);
          Navigation.navigateToHome(context);
        } else {
          _ref.read(userProvider.notifier).update((state) => userModel);
          Routemaster.of(context).push('/verify_email');
        }
      },
    );
  }

  sendEmailVerification(BuildContext context, String email) async {
    final res =
        await _ref.read(authApiProvider).sendEmailVerification(email: email);
    res.fold(
      (l) {
        print(l.message);
        errorSnackBar(title: 'Error', message: l.toString(), context: context);
      },
      (r) {
        print('Email sent');
        successSnackBar(
            title: 'Email sent',
            message: 'Please Check your inbox and verify your email',
            context: context);
      },
    );
  }

  sendPasswordResetEmail(BuildContext context, String email) async {
    state = true;
    final res = await _ref.read(authApiProvider).sendPasswordResetEmail(email);
    state = false;
    res.fold(
      (l) {
        
        print(l.message);
        errorSnackBar(title: 'Error', message: l.toString(), context: context);
      },
      (r) {
        print('Password resent link sent sent');
        successSnackBar(
            title: 'Email sent on $email',
            message: 'Please Check your inbox and reset your password',
            context: context);
      },
    );
  }

  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
      }
    });
  }

  checkEmailVerificationStatus(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Navigation.navigateToHome(context);
      successSnackBar(
        title: 'Verification Successful',
        message: 'Now you can login with your account',
        context: context,
      );
    }
    ;
  }

  void logOut() {
    _ref.read(authApiProvider).logOut();
    _ref.read(userProvider.notifier).update((state) => null);
  }
}

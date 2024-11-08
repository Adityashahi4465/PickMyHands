import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/firebase_constants.dart';
import '../core/providers/firebase_providers.dart';
import '../core/core.dart';
import '../core/utils/exceptions/auth_exceptions.dart';
import '../core/utils/exceptions/firebase_exceptions.dart';
import '../core/utils/exceptions/platform_exception.dart';
import '../core/utils/exceptions/platform_exceptions.dart';
import '../core/utils/failure.dart';
import '../models/user_model.dart';
import 'apis.dart';

final authApiProvider = Provider(
  (ref) => AuthAPI(
    // Now we are using provider for firebase instance as well insted of creating like FirebaseFirestore.instance
    // How I am going to use Firebase provers into this provider?, that is that **ref** is for
    // ref allows us to talk with other providers. IT provides us many methods ref.Read() & ref.Watch most is most important
    // ref.read is usually used out side of build Context means you don't want to read any changes mad in providers
    firestore: ref.read(
        firestoreProvider), //It gives the instance if firebaseFirestore class
    auth: ref.read(
        authProvider), // It all provers coming from firebase_providers.dart
  ),
);

abstract class IAuthAPI {
  FutureEither<UserModel> registerWithEmailAndPassword({
    required UserModel userModel,
    required String password,
  });
  FutureEither<UserModel> logIn({
    required String password,
    required String email,
  });

  void logOut();
  FutureEitherVoid sendEmailVerification({required String email});
}

class AuthAPI implements IAuthAPI {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  AuthAPI({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.user);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  @override
  FutureEither<UserModel> registerWithEmailAndPassword({
    required UserModel userModel,
    required String password,
  }) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );

      final newUserModel = userModel.copyWith(
        profilePicture: user.additionalUserInfo?.profile?['picture'].toString(),
        id: user.user!.uid,
      );

      await _user.doc(newUserModel.id).set(newUserModel.toMap());

      return right(newUserModel);
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  FutureEither<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final existingUserModel = await _user.doc(user.user!.uid).get();

      if (existingUserModel.exists) {
        final userModel =
            UserModel.fromMap(existingUserModel.data() as Map<String, dynamic>);
        return right(userModel);
      } else {
        // Handle the case where user data doesn't exist (optional)
        return left(
          const Failure('User data not found.'),
        );
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid sendEmailVerification({required String email}) async {
    try {
      return right(_auth.currentUser?.sendEmailVerification());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      return left(
        const Failure(
          'Something went wrong. Please try again',
      ),
      );
    }
  }

  FutureEitherVoid sendPasswordResetEmail(String email) async {
    try {
      return right(_auth.sendPasswordResetEmail(email: email));
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      return left(
        const Failure(
          'Something went wrong. Please try again',
        ),
      );
    }
  }

  @override
  void logOut() {
    _auth.signOut();
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

import '../constants/firebase_constants.dart';
import '../core/providers/firebase_providers.dart';
import '../core/core.dart';
import '../models/user_model.dart';
import 'apis.dart';

final userApiProvider = Provider((ref) {
  return UserAPI(firestore: ref.watch(firestoreProvider));
});

abstract class IUserAPI {
  FutureEither updateUser({
    required UserModel userModel,
  });
  Stream<UserModel> getUserDataById(String uid);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _firestore;

  UserAPI({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.user);

  @override
  Stream<UserModel> getUserDataById(String uid) {
    return _users.doc(uid).snapshots().distinct().map(
          (event) => UserModel.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  Stream<List<UserModel>> getAllUsers() {
    return _users.snapshots().map(
          (event) => event.docs
              .map(
                (e) => UserModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  @override
  FutureEither<UserModel> updateUser({
    required UserModel userModel,
  }) async {
    try {
      await _users.doc(userModel.id).update(userModel.toMap());

      // Fetch the updated user after the update
      final updatedUser = await _users.doc(userModel.id).get();

      // Convert the data from Firestore to UserModel
      final UserModel updatedModel =
          UserModel.fromMap(updatedUser.data() as Map<String, dynamic>);

      return right(updatedModel); // Assuming left is for success
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); // Assuming right is for failure
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

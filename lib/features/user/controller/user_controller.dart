import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/user_api.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>(
  (ref) => UserController(
    userAPI: ref.watch(userApiProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  ),
);

final getUserDataByIdProvider = StreamProvider.family((ref, String id) {
  final userController = ref.watch(userControllerProvider.notifier);
  return userController.getUserDataById(id: id);
});
final getAllUsersrovider = StreamProvider((
  ref,
) {
  final userController = ref.watch(userControllerProvider.notifier);
  return userController.getAllUsers();
});

class UserController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserController({
    required UserAPI userAPI,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userAPI = userAPI,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false); // loading while asynchronous tasks initially false

  Stream<UserModel> getUserDataById({required String id}) {
    return _userAPI.getUserDataById(id);
  }

  Stream<List<UserModel>> getAllUsers() {
    return _userAPI.getAllUsers();
  }

  Future<void> updateUser({
    required String name,
    required String phone,
    required String disability,
    required File? profileFile,
    required BuildContext context,
  }) async {
    state = true;
    String profilepic = '';
    final user = _ref.read(userProvider)!;
    if (profileFile != null) {
      // profile/memes
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.id,
        webFile: null,
        file: profileFile,
      );
      res.fold(
        (l) => errorSnackBar(
          context: context,
          message: l.message,
          title: 'Failed!',
        ),
        (r) => profilepic = r,
      );
    } else {
      profilepic = user.profilePicture;
    }
    final updatedUser = UserModel(
      id: user.id,
      name: name,
      email: user.email,
      phoneNumber: phone,
      dob: user.dob,
      gender: user.gender,
      disability: disability,
      profilePicture: profilepic,
      disabilityCerti: user.disabilityCerti,
    );
    final res = await _userAPI.updateUser(userModel: updatedUser);
    state = false;
    res.fold(
      (l) => showCustomSnackbar(context, l.message, _ref),
      (r) {
        _ref.read(userProvider.notifier).update(
              (state) => r,
            );
        _ref.invalidate(
          getUserDataByIdProvider(user.id),
        );
        // _ref.invalidate(
        //     getBookmarkedComplaintsProvider); // Refresh bookmarkedComplaintsProvider
      },
    );
  }
}

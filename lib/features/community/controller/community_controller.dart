import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../apis/community_api.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/community_model.dart';
import '../../../models/message_id.dart';
import '../../auth/controller/auth_controller.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      storageRepository: storageRepository,
      ref: ref);
});

final getCommunityByIdProvider = StreamProvider.family((ref, String id) {
  return ref.read(communityControllerProvider.notifier).getCommunityById(id);
});
final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityMessagesProvider =
    StreamProvider.family((ref, String communityId) {
  return ref
      .read(communityControllerProvider.notifier)
      .getCommunityMessages(communityId: communityId);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(
    String name,
    BuildContext context,
    File? bannerFile,
    Uint8List? bannerWebFile,
  ) async {
    state = true;
    var groupIcon = '';
    if (bannerFile != null || bannerWebFile != null) {
      // communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: name,
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
          (l) => errorSnackBar(
                context: context,
                message: l.message,
                title: 'Failed!',
              ),
          (r) => groupIcon =
              r // Since avatar is final we are using copyWith function
          );
    }

    final uid = _ref.read(userProvider)!.id;
    final communityId = const Uuid().v1();

    Community community = Community(
      id: communityId,
      name: name,
      members: [uid],
      admin: uid,
      groupIcon: groupIcon,
      recentMessage: '',
      kickedMembers: {},
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
        (l) => errorSnackBar(
              context: context,
              message: l.message,
              title: 'Failed!',
            ), (r) {
      successSnackBar(
          context: context,
          message: 'Your Community "$name" Created Successfully!',
          title: 'Success');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if (community.members.contains(user.id)) {
      res = await _communityRepository.leaveCommunity(community.id, user.id);
    } else {
      res = await _communityRepository.joinCommunity(community.id, user.id);
    }
    res.fold(
        (l) => errorSnackBar(
              context: context,
              message: l.message,
              title: 'Failed!',
            ), (r) {
      if (!community.members.contains(user.email)) {
        successSnackBar(
            context: context,
            message: ' Community left Successfully!',
            title: 'Success');
      } else {
        successSnackBar(
            context: context,
            message: ' Community Joined Successfully!',
            title: 'Success');
      }
    });
  }

  Stream<List<Message>> getCommunityMessages({required String communityId}) {
    return _communityRepository.getCommunityChats(
      id: communityId,
    );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String communityId,
  }) {
    final message = Message(
      id: const Uuid().v1(),
      senderId: _ref.read(userProvider)!.id.toString(),
      text: text,
      timestamp: Timestamp.now(),
    );

    _ref.read(communityRepositoryProvider).sendTextMessage(
          message: message,
          communityId: communityId,
        );
  }

  void removeMember(String communityId, String userId) async {
    _communityRepository.removeMember(communityId, userId);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.id;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityById(String id) {
    return _communityRepository.getCommunityById(id);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void getMembersOfCommunity() {}
  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => errorSnackBar(
        context: context,
        message: l.message,
        title: 'Failed!',
      ),
      (r) => Routemaster.of(context).pop(),
    );
  }

  // Stream<List<Articles>> getCommunityArticles(String name) {
  //   return _communityRepository.getCommunityArticles(name);
  // }
}

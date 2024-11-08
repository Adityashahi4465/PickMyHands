import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/firebase_constants.dart';
import '../core/providers/firebase_providers.dart';
import '../core/type_defs.dart';
import '../core/utils/failure.dart';
import '../models/community_model.dart';
import '../models/message_id.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(
    firestore: ref.watch(
      firestoreProvider,
    ),
  );
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureEitherVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.id).get();
      if (communityDoc.exists) {
        throw ' Community with the same name already exists!';
      }
      return right(_communities.doc(community.id).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEitherVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([
          userId
        ]), // FieldValue function to add elements to existing list in firebase
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEitherVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayRemove(
          [userId],
        ), // FieldValue function to add elements to existing list in firebase
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<Community> communities = [];
        for (var doc in event.docs) {
          communities
              .add(Community.fromMap(doc.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<Community> getCommunityById(String id) {
    return _communities.doc(id).snapshots().distinct().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureEitherVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      print(communities);
      return communities;
    });
  }

  FutureEitherVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Message>> getCommunityChats({
    required String id,
  }) {
    return _firestore
        .collection(FirebaseConstants.communityCollection)
        .doc(id)
        .collection(FirebaseConstants.chatsCollection)
        .orderBy('timestamp')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  FutureEitherVoid removeMember(String communityId, String userId) async {
    try {
      return right(_communities.doc(communityId).update({
        'members': FieldValue.arrayRemove(
          [userId],
        ), // FieldValue function to add elements to existing list in firebase
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid sendTextMessage({
    required Message message,
    required String communityId,
  }) async {
    // Sender
    await _firestore
        .collection(FirebaseConstants.communityCollection)
        .doc(communityId)
        .collection(FirebaseConstants.chatsCollection)
        .doc(message.id)
        .set(
          message.toMap(),
        );
    await _communities.doc(communityId).update({
      "recentMessage": message.text,
    });
  }

  // Future<List<Articles>> getCommunityArticles(String uid) {
  //   var future = _articles
  //       .where('communityName', isEqualTo: uid)
  //       .orderBy('postedOn', descending: true)
  //       .get()
  //       .then((event) => event.docs
  //           .map(
  //             (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
  //           )
  //           .toList());
  //   print('getCommunityArticles fatching data');
  //   return future;
  // }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communityCollection);
}

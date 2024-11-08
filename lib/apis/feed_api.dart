// repository
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/firebase_constants.dart';
import '../core/providers/firebase_providers.dart';
import '../core/type_defs.dart';
import '../core/utils/failure.dart';
import '../models/article_model.dart';

final articleRepositoryProvider = Provider((ref) {
  return ArticlesRepository(firestore: ref.watch(firestoreProvider));
});

class ArticlesRepository {
  final FirebaseFirestore _firestore;
  ArticlesRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _articles =>
      _firestore.collection(FirebaseConstants.articlesCollection);

  FutureEitherVoid addArticle(Articles article) async {
    try {
      return right(_articles.doc(article.id).set(article.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Articles>> fatchUserArticles() {
    return _articles.orderBy('postedOn', descending: true).snapshots().map(
        (event) => event.docs
            .map((e) => Articles.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Articles>> fatchGuestArticles() {
    return _articles
        .orderBy('postedOn', descending: true)
        .limit(30)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Articles.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  // Stream<List<Articles>> fatchUserCommunityArticles(
  //     List<Community> communities) {
  //   return _articles
  //       .where('communityName',
  //           whereIn: communities.map((e) => e.name).toList())
  //       .orderBy('postedOn', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map(
  //             (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
  //           )
  //           .toList());
  // }

  Stream<Articles> getArticleById(String articleId) {
    return _articles
        .doc(articleId)
        .snapshots()
        .map((event) => Articles.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEitherVoid deleteArticle(Articles article) async {
    try {
      return right(_articles.doc(article.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVote(Articles articles, String userId) async {
    if (articles.downVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (articles.upVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downVote(Articles articles, String userId) async {
    if (articles.upVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (articles.downVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }
}

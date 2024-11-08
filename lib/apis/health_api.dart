import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../constants/firebase_constants.dart';
import '../core/providers/firebase_providers.dart';
import '../core/type_defs.dart';
import '../core/utils/failure.dart';
import '../models/document_model.dart';

final healthRepositoryProvider = Provider((ref) {
  return HealthRepository(
      firestore: ref.watch(
    firestoreProvider,
  ));
});

class HealthRepository {
  final FirebaseFirestore _firestore;
  HealthRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureEitherVoid createDocument(DocumentModel doc) async {
    try {
      var documentDoc = await _documents.doc(doc.id).get();
      if (documentDoc.exists) {
        throw ' Doc with the same name already exists!';
      }
      return right(_documents.doc(doc.id).set(doc.toMap()));
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

  Stream<List<DocumentModel>> getUserDocuments(String uid) {
    return _documents.where('userId', isEqualTo: uid).snapshots().map(
      (event) {
        List<DocumentModel> docs = [];
        for (var doc in event.docs) {
          docs.add(DocumentModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return docs;
      },
    );
  }

  Stream<DocumentModel> getDocumentById(String id) {
    return _documents.doc(id).snapshots().distinct().map(
          (event) =>
              DocumentModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureEitherVoid deleteDocument(String id) async {
    try {
      return right(_documents.doc(id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEitherVoid editDocument(DocumentModel doc) async {
    try {
      return right(_documents.doc(doc.id).update(doc.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _documents =>
      _firestore.collection(FirebaseConstants.documentCollection);
}

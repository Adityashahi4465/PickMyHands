import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../apis/community_api.dart';
import '../../../apis/health_api.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/community_model.dart';
import '../../../models/document_model.dart';
import '../../../models/message_id.dart';
import '../../auth/controller/auth_controller.dart';

final userDocumentsProvider = StreamProvider((ref) {
  final documentController = ref.watch(healthControllerProvider.notifier);
  return documentController.getUserDocuments();
});

final healthControllerProvider =
    StateNotifierProvider<DocumentController, bool>((ref) {
  final healthRepository = ref.watch(healthRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return DocumentController(
      healthRepository: healthRepository,
      storageRepository: storageRepository,
      ref: ref);
});

final getDocumentByIdProvider = StreamProvider.family((ref, String id) {
  return ref.read(healthControllerProvider.notifier).getDocumentById(id);
});

final getUserDocumentProvider = StreamProvider((ref) {
  return ref.read(healthControllerProvider.notifier).getUserDocuments();
});

class DocumentController extends StateNotifier<bool> {
  final HealthRepository _healthRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  DocumentController({
    required HealthRepository healthRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _healthRepository = healthRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createDocument(
    String title,
    String description,
    BuildContext context,
    File? docFile,
    Uint8List? docWebFile,
  ) async {
    state = true;
    var docUrl = '';
    if (docFile != null || docWebFile != null) {
      // communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'documents',
        id: title,
        file: docFile,
        webFile: docWebFile,
      );
      res.fold(
          (l) => errorSnackBar(
                context: context,
                message: l.message,
                title: 'Failed!',
              ),
          (r) =>
              docUrl = r // Since avatar is final we are using copyWith function
          );
    }

    final uid = _ref.read(userProvider)!.id;
    final docId = const Uuid().v1();
    DocumentModel documentModel = DocumentModel(
      id: docId,
      userId: uid,
      title: title,
      description: description,
      document: docUrl,
      createdOn: Timestamp.now(),
      lastEdit: Timestamp.now(),
    );
    final res = await _healthRepository.createDocument(documentModel);
    state = false;
    res.fold(
        (l) => errorSnackBar(
              context: context,
              message: l.message,
              title: 'Failed!',
            ), (r) {
      successSnackBar(
          context: context,
          message: 'Your Document "$title" Created Successfully!',
          title: 'Success');
      Routemaster.of(context).pop();
    });
  }

  void deleteDocument(String id) {
    _healthRepository.deleteDocument(id);
  }

  Stream<List<DocumentModel>> getUserDocuments() {
    final uid = _ref.read(userProvider)!.id;
    return _healthRepository.getUserDocuments(uid);
  }

  Stream<DocumentModel> getDocumentById(String id) {
    return _healthRepository.getDocumentById(id);
  }
}

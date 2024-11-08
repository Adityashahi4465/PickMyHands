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
import '../../../constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/community_model.dart';
import '../../../models/counsellor_appointment_model.dart';
import '../../../models/message_id.dart';
import '../../../models/volunteers_appointment_model.dart';
import '../../auth/controller/auth_controller.dart';

final userAppointmentsProvider = StreamProvider((ref) {
  final contactMeController = ref.watch(contactMeControllerProvider.notifier);
  return contactMeController.getUserAppointments();
});
final userVolunteersProvider = StreamProvider((ref) {
  final contactMeController = ref.watch(contactMeControllerProvider.notifier);
  return contactMeController.getUserVolunteers();
});

final contactMeControllerProvider =
    StateNotifierProvider<ContactMeController, bool>((ref) {
  final healthRepository = ref.watch(healthRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ContactMeController(
      firestore: ref.watch(
        firestoreProvider,
      ),
      storageRepository: storageRepository,
      ref: ref);
});

// final getDocumentByIdProvider = StreamProvider.family((ref, String id) {
//   return ref.read(healthControllerProvider.notifier).getDocumentById(id);
// });

class ContactMeController extends StateNotifier<bool> {
  final Ref _ref;
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;

  ContactMeController({
    required Ref ref,
    required FirebaseFirestore firestore,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _firestore = firestore,
        _storageRepository = storageRepository,
        super(false);

  void bookAppointment(String reason, DateTime appointmentTime, String id,
      BuildContext context) async {
    try {
      state = true;
      final doc = _firestore
          .collection(FirebaseConstants.counsellorCollection)
          .doc(id)
          .collection(FirebaseConstants.counsellorAppointmentsCollection)
          .doc();
      await doc.set(
        CounsellorAppointmentModel(
          reason: reason,
          id: doc.id,
          userId: _ref.read(userProvider)!.id,
          appointmentTime: Timestamp.fromDate(appointmentTime),
          isAccepted: false,
        ).toMap(),
      );
      state = false;
      // ignore: use_build_context_synchronously
      successSnackBar(
        context: context,
        message: 'Your Appointment Booked Successfully!',
        title: 'Success',
      );
    } catch (e) {
      state = false;

      // ignore: use_build_context_synchronously
      errorSnackBar(
        context: context,
        message: e.toString(),
        title: 'Failed!',
      );
    }
  }

  void bookVolunteer(String reason, DateTime appointmentTime, String id,
      BuildContext context) async {
    try {
      state = true;
      final doc = _firestore
          .collection(FirebaseConstants.volunteersCollection)
          .doc(id)
          .collection(FirebaseConstants.volunteersAppointmentsCollection)
          .doc();
      await doc.set(
        VolunteersAppointmentModel(
          reason: reason,
          id: doc.id,
          userId: _ref.read(userProvider)!.id,
          appointmentTime: Timestamp.fromDate(appointmentTime),
          isAccepted: false,
        ).toMap(),
      );
      state = false;
      // ignore: use_build_context_synchronously
      successSnackBar(
        context: context,
        message: 'Your Appointment Booked Successfully!',
        title: 'Success',
      );
    } catch (e) {
      state = false;

      // ignore: use_build_context_synchronously
      errorSnackBar(
        context: context,
        message: e.toString(),
        title: 'Failed!',
      );
    }
  }

  Stream<List<VolunteersAppointmentModel>> getUserVolunteers() {
    final uid = _ref.read(userProvider)!.id;

    return _firestore
        .collectionGroup(FirebaseConstants.volunteersAppointmentsCollection)
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((appointmentsSnapshot) {
      List<VolunteersAppointmentModel> volunteers = [];

      for (var appointmentDoc in appointmentsSnapshot.docs) {
        var volunteer = VolunteersAppointmentModel.fromMap(
          appointmentDoc.data(),
        );

        volunteers.add(volunteer);
      }

      print(volunteers);
      return volunteers;
    });
  }

  Stream<List<CounsellorAppointmentModel>> getUserAppointments() {
    final uid = _ref.read(userProvider)!.id;

    return _firestore
        .collectionGroup(
            'counsellor_appointments') // Use collectionGroup to query across subcollections
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((appointmentsSnapshot) {
      List<CounsellorAppointmentModel> appointments = [];

      for (var appointmentDoc in appointmentsSnapshot.docs) {
        var appointment = CounsellorAppointmentModel.fromMap(
          appointmentDoc.data(),
        );

        appointments.add(appointment);
      }

      print(appointments);
      return appointments;
    });
  }

  // void createDocument(
  //   String title,
  //   String description,
  //   BuildContext context,
  //   File? docFile,
  //   Uint8List? docWebFile,
  // ) async {
  //   state = true;
  //   var docUrl = '';
  //   if (docFile != null || docWebFile != null) {
  //     // communities/banner/memes
  //     final res = await _storageRepository.storeFile(
  //       path: 'documents',
  //       id: title,
  //       file: docFile,
  //       webFile: docWebFile,
  //     );
  //     res.fold(
  //         (l) => errorSnackBar(
  //               context: context,
  //               message: l.message,
  //               title: 'Failed!',
  //             ),
  //         (r) =>
  //             docUrl = r // Since avatar is final we are using copyWith function
  //         );
  //   }

  //   final uid = _ref.read(userProvider)!.id;
  //   final docId = const Uuid().v1();
  //   DocumentModel documentModel = DocumentModel(
  //     id: docId,
  //     userId: uid,
  //     title: title,
  //     description: description,
  //     document: docUrl,
  //     createdOn: Timestamp.now(),
  //     lastEdit: Timestamp.now(),
  //   );
  //   // final res = await _healthRepository.createDocument(documentModel);
  //   state = false;
  //   res.fold(
  //       (l) => errorSnackBar(
  //             context: context,
  //             message: l.message,
  //             title: 'Failed!',
  //           ), (r) {
  //     successSnackBar(
  //         context: context,
  //         message: 'Your Community "$title" Created Successfully!',
  //         title: 'Success');
  //     Routemaster.of(context).pop();
  //   });
  // }

  // Stream<List<DocumentModel>> getUserDocuments() {
  //   final uid = _ref.read(userProvider)!.id;
  //   return _healthRepository.getUserDocuments(uid);
  // }

  // Stream<DocumentModel> getDocumentById(String id) {
  //   return _healthRepository.getDocumentById(id);
  // }
}

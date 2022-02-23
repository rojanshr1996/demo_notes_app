import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_constants.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldname: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId).get().then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldname] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) => notes.snapshots().map(
        (event) =>
            event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) => note.ownerUserId == ownerUserId),
      );

  Future<void> updateNote({required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldname: text});
    } catch (e) {
      throw CouldNotGetUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotGetDeleteNoteException();
    }
  }
}

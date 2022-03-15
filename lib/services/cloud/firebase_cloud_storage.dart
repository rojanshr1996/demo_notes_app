import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_constants.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  final users = FirebaseFirestore.instance.collection('users');
  final storageDestination = "attachments/";
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldname: '',
      titleFieldname: '',
      colorFieldname: '',
      imageUrlFieldname: '',
      fileUrlFieldname: '',
    });

    final fetchedNote = await document.get();
    return CloudNote(
        documentId: fetchedNote.id, ownerUserId: ownerUserId, text: "", title: "", imageUrl: "", fileUrl: "");
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId).get().then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) => notes.snapshots().map(
        (event) =>
            event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) => note.ownerUserId == ownerUserId),
      );

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
    String color = "",
    String imageUrl = "",
    String fileUrl = "",
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldname: text,
        titleFieldname: title,
        colorFieldname: color,
        imageUrlFieldname: imageUrl,
        fileUrlFieldname: fileUrl
      });
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

  UploadTask? uploadFile(String fileName, File file) {
    try {
      final ref = FirebaseStorage.instance.ref("$storageDestination$fileName");
      return ref.putFile(file);
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  UploadTask? uploadBytes(String fileName, Uint8List bytes) {
    try {
      final ref = FirebaseStorage.instance.ref("$storageDestination$fileName");
      return ref.putData(bytes);
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  Future<void> deleteFile(String file) async {
    try {
      await FirebaseStorage.instance.refFromURL(file).delete();
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  // User Collection
  Future<Iterable<UserModel>> getUser({required String ownerUserId}) async {
    try {
      return await users.where(ownerUserIdFieldName, isEqualTo: ownerUserId).get().then(
            (value) => value.docs.map((doc) => UserModel.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetUserException();
    }
  }

  Stream<Iterable<UserModel>> userData({required String ownerUserId}) => users.snapshots().map(
        (event) => event.docs.map((doc) => UserModel.fromSnapshot(doc)).where((user) => user.userId == ownerUserId),
      );

  Future<void> updateUser({
    required String documentId,
    required String name,
    String phone = "",
    String address = "",
    String profileUrl = "",
  }) async {
    try {
      await users.doc(documentId).update({
        fullNameFieldName: name,
        profileImageFieldName: profileUrl,
        phoneFieldName: phone,
        addressFieldName: address
      });
    } catch (e) {
      throw CouldNotGetUpdateUserException();
    }
  }
}

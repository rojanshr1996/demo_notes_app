import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String title;
  final Color? color;

  const CloudNote(
      {required this.documentId, required this.ownerUserId, required this.text, required this.title, this.color});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldname] as String,
        title = snapshot.data()[titleFieldname] as String,
        color = _parseColor(snapshot.data()[colorFieldname]);
}

Color? _parseColor(String? colorInt) =>
    colorInt == null || colorInt == "" ? const Color(0xFFFFFFFF) : Color(int.parse(colorInt));

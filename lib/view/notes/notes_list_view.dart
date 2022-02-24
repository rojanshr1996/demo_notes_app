import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback? onDeleteNote;
  final NoteCallback? onTap;
  const NotesListView({Key? key, required this.notes, this.onDeleteNote, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, childAspectRatio: 5 / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: notes.length,
      itemBuilder: (BuildContext ctx, index) {
        final note = notes.elementAt(index);
        return Card(
          child: InkWell(
            onTap: () {
              onTap!(note);
            },
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(note.text, maxLines: 4, softWrap: true, overflow: TextOverflow.ellipsis),
              ),
              footer: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.cRed, size: 22),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote!(note);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// SQFLITE USAGE
// typedef NoteCallback = void Function(DatabaseNote note);

// class NotesListView extends StatelessWidget {
//   final List<DatabaseNote> notes;
//   final NoteCallback? onDeleteNote;
//   final NoteCallback? onTap;
//   const NotesListView({Key? key, required this.notes, this.onDeleteNote, this.onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return ListTile(
//             onTap: () {
//               onTap!(note);
//             },
//             title: Text(note.text, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete, color: AppColors.cRed),
//               onPressed: () async {
//                 final shouldDelete = await showDeleteDialog(context);
//                 if (shouldDelete) {
//                   onDeleteNote!(note);
//                 }
//               },
//             ),
//           );
//         });
//   }
// }

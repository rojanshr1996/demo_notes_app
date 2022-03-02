import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback? onDeleteNote;
  final NoteCallback? onTap;
  final NoteCallback? onLongPress;
  const NotesListView({Key? key, required this.notes, this.onDeleteNote, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, childAspectRatio: 5 / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final note = notes.elementAt(index);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: AppColors.cDarkBlueAccent,
              elevation: 5,
              shadowColor: AppColors.cDarkBlue,
              child: InkWell(
                onTap: () {
                  onTap!(note);
                },
                onLongPress: () {
                  onLongPress!(note);
                },
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      note.text,
                      maxLines: 6,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.cLightShade),
                    ),
                  ),
                  // footer: IconButton(
                  //   icon: const Icon(Icons.delete, color: AppColors.cRed, size: 22),
                  //   onPressed: () async {
                  //     final shouldDelete = await showDeleteDialog(context);
                  //     if (shouldDelete) {
                  //       onDeleteNote!(note);
                  //     }
                  //   },
                  // ),
                ),
              ),
            );
          },
          childCount: notes.length,
        ),
      ),
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

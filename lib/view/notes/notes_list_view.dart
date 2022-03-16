import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef NoteCallback = void Function(CloudNote note);
typedef ImageCallback = void Function(String imageUrl);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback? onTap;
  final NoteCallback? onLongPress;
  final ImageCallback? onImageTap;
  const NotesListView({Key? key, required this.notes, this.onTap, this.onLongPress, this.onImageTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, childAspectRatio: 1 / 1.3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final note = notes.elementAt(index);
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: note.color ?? AppColors.transparent, width: 4)),
              color: Theme.of(context).primaryColor,
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.shadow,
              child: InkWell(
                onTap: () {
                  onTap!(note);
                },
                onLongPress: () {
                  onLongPress!(note);
                },
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          note.text,
                          maxLines: 4,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        note.imageUrl == "" && note.fileUrl == ""
                            ? const SizedBox()
                            : Row(
                                children: [
                                  note.imageUrl == ""
                                      ? const SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            if (note.imageUrl != "") {
                                              onImageTap!(note.imageUrl!);
                                            }
                                          },
                                          child: Hero(
                                            tag: note.imageUrl!,
                                            child: Container(
                                              height: 36,
                                              width: 36,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).scaffoldBackgroundColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: "${note.imageUrl}",
                                                  fit: BoxFit.cover,
                                                  memCacheHeight: 50,
                                                  errorWidget: (context, url, error) => Icon(
                                                    Icons.error,
                                                    color: Theme.of(context).colorScheme.background,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(width: note.imageUrl == "" ? 0 : 15),
                                  note.fileUrl == ""
                                      ? const SizedBox()
                                      : Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.file_copy,
                                              size: 20, color: Theme.of(context).colorScheme.background),
                                        ),
                                  const Spacer(),
                                  note.createdDate == ""
                                      ? const SizedBox()
                                      : Text(
                                          DateFormat.Md().format(DateTime.parse(note.createdDate!)),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: semibold),
                                        )
                                ],
                              )
                      ],
                    ),
                  ),
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

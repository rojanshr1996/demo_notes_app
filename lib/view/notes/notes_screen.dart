import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/firebase_cloud_storage.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:demo_app_bloc/view/notes/notes_list_view.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/default_loading_screen.dart';
import 'package:demo_app_bloc/widgets/no_data_widget.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:demo_app_bloc/widgets/sliver_header_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final FirebaseCloudStorage _notesService;
  final AuthServices _auth = AuthServices();

  String get userId => _auth.currentUser!.id;

  double top = 0.0;

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 120;
  // double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  void initState() {
    debugPrint(userId);
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset = _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
          () => _controller.animateTo(snapOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cDarkBlue,
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (_) {
                    _snapAppbar();
                    return false;
                  },
                  child: CupertinoScrollbar(
                    controller: _controller,
                    child: CustomScrollView(
                      controller: _controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          stretch: true,
                          centerTitle: false,
                          flexibleSpace: SliverHeaderText(
                            maxHeight: maxHeight,
                            minHeight: minHeight,
                            notesLength: allNotes.length,
                          ),
                          expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
                          actions: [
                            IconButton(
                              onPressed: () {
                                Utilities.openNamedActivity(context, Routes.createUpdateNote);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        if (allNotes.isNotEmpty)
                          NotesListView(
                            notes: allNotes,
                            onTap: (note) {
                              Navigator.pushNamed(context, Routes.createUpdateNote, arguments: note);
                            },
                            onLongPress: (note) {
                              showBottomSheet(
                                context: context,
                                onDeleteTap: () async {
                                  await _notesService.deleteNote(documentId: note.documentId);
                                  Utilities.closeActivity(context);
                                },
                                onShareTap: () async {
                                  Utilities.closeActivity(context);
                                  if (note.text.isEmpty) {
                                    await showCannotShareEmptyNoteDialog(context);
                                  } else {
                                    Share.share(note.text);
                                  }
                                },
                              );
                            },
                          )
                        else
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: NoDataWidget(title: "No data"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                return DefaultLoadingScreen(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Utilities.openNamedActivity(context, Routes.createUpdateNote);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                );
              }

            default:
              return DefaultLoadingScreen(
                maxHeight: maxHeight,
                minHeight: minHeight,
                actions: [
                  IconButton(
                    onPressed: () {
                      Utilities.openNamedActivity(context, Routes.createUpdateNote);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  showBottomSheet({required BuildContext context, VoidCallback? onDeleteTap, VoidCallback? onShareTap}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      backgroundColor: AppColors.cDarkBlueAccent,
      builder: (context) {
        return Container(
          color: AppColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: onShareTap,
                leading: const Icon(Icons.share, color: AppColors.cDarkBlueLight),
                title: const Text("Share", style: CustomTextStyle.subtitleTextLight),
              ),
              ListTile(
                onTap: onDeleteTap,
                leading: const Icon(Icons.delete, color: AppColors.cRedAccent),
                title: const Text("Delete", style: CustomTextStyle.subtitleTextLight),
              ),
            ],
          ),
        );
      },
    );
  }
}



// SQFLITE USAGE
// class NotesScreen extends StatefulWidget {
//   const NotesScreen({Key? key}) : super(key: key);

//   @override
//   State<NotesScreen> createState() => _NotesScreenState();
// }

// class _NotesScreenState extends State<NotesScreen> {
//   late final NotesService _notesService;
//   final AuthServices _auth = AuthServices();

//   String get userEmail => _auth.currentUser!.email;

//   @override
//   void initState() {
//     debugPrint(userEmail);
//     _notesService = NotesService();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notes"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Utilities.openNamedActivity(context, Routes.createUpdateNote);
//             },
//             icon: const Icon(Icons.add),
//           ),
//           IconButton(
//             onPressed: () {
//               BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateuser(email: userEmail),
//         builder: ((context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                 stream: _notesService.allNotes,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                     case ConnectionState.active:
//                       if (snapshot.hasData) {
//                         final allNotes = snapshot.data as List<DatabaseNote>;
//                         return NotesListView(
//                             notes: allNotes,
//                             onDeleteNote: (note) async {
//                               await _notesService.deleteNote(id: note.id);
//                             },
//                             onTap: (note) {
//                               // Utilities.openNamedActivity(context, Routes.createUpdateNote, )
//                               Navigator.pushNamed(context, Routes.createUpdateNote, arguments: note);
//                             });
//                       } else {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                     default:
//                       return const Center(child: CircularProgressIndicator());
//                   }
//                 },
//               );
//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         }),
//       ),
//     );
//   }
// }



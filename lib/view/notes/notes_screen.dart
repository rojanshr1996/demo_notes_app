import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/crud/notes_service.dart';
import 'package:demo_app_bloc/view/notes/notes_list_view.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final NotesService _notesService;
  final AuthServices _auth = AuthServices();

  String get userEmail => _auth.currentUser!.email;

  @override
  void initState() {
    debugPrint(userEmail);
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Utilities.openNamedActivity(context, Routes.createUpdateNote);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateuser(email: userEmail),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                            notes: allNotes,
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(id: note.id);
                            },
                            onTap: (note) {
                              // Utilities.openNamedActivity(context, Routes.createUpdateNote, )
                              Navigator.pushNamed(context, Routes.createUpdateNote, arguments: note);
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }

                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}

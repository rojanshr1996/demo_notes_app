import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/firebase_cloud_storage.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesScreen extends StatefulWidget {
  final CloudNote? note;
  const CreateUpdateNotesScreen({Key? key, this.note}) : super(key: key);

  @override
  State<CreateUpdateNotesScreen> createState() => _CreateUpdateNotesScreenState();
}

class _CreateUpdateNotesScreenState extends State<CreateUpdateNotesScreen> {
  final AuthServices _auth = AuthServices();
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    debugPrint("$_note");
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // final widgetNote = context.getArgument<DatabaseNote>();

    if (widget.note != null) {
      _note = widget.note;
      _textController.text = widget.note!.text;
      return widget.note!;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = _auth.currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    debugPrint(text);
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Create new note"),
      ),
      body: Container(
        height: Utilities.screenHeight(context),
        padding: const EdgeInsets.all(25),
        child: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.displaySmall,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Enter new note... ",
                    hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                );
              default:
                return const Center(child: SimpleCircularLoader());
            }
          },
        ),
      ),
    );
  }
}

// SQFLITE USAGE
// class CreateUpdateNotesScreen extends StatefulWidget {
//   final DatabaseNote? note;
//   const CreateUpdateNotesScreen({Key? key, this.note}) : super(key: key);

//   @override
//   State<CreateUpdateNotesScreen> createState() => _CreateUpdateNotesScreenState();
// }

// class _CreateUpdateNotesScreenState extends State<CreateUpdateNotesScreen> {
//   final AuthServices _auth = AuthServices();
//   DatabaseNote? _note;
//   late final NotesService _notesService;
//   late final TextEditingController _textController;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     _textController = TextEditingController();
//     super.initState();
//   }

//   void _textControllerListener() async {
//     final note = _note;
//     debugPrint("$_note");
//     if (note == null) {
//       return;
//     }
//     final text = _textController.text;
//     await _notesService.updateNote(note: note, text: text);
//   }

//   void _setupTextControllerListener() {
//     _textController.removeListener(_textControllerListener);
//     _textController.addListener(_textControllerListener);
//   }

//   Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
//     // final widgetNote = context.getArgument<DatabaseNote>();

//     if (widget.note != null) {
//       _note = widget.note;
//       _textController.text = widget.note!.text;
//       return widget.note!;
//     }

//     final existingNote = _note;
//     if (existingNote != null) {
//       return existingNote;
//     }
//     final currentUser = _auth.currentUser!;
//     final email = currentUser.email;
//     final owner = await _notesService.getUser(email: email);
//     final newNote = await _notesService.createNote(owner: owner);
//     _note = newNote;
//     return newNote;
//   }

//   void _deleteNoteIfTextIsEmpty() {
//     final note = _note;
//     if (_textController.text.isEmpty && note != null) {
//       _notesService.deleteNote(id: note.id);
//     }
//   }

//   void _saveNoteIfTextNotEmpty() async {
//     final note = _note;
//     final text = _textController.text;
//     debugPrint(text);
//     if (note != null && text.isNotEmpty) {
//       await _notesService.updateNote(note: note, text: text);
//     }
//   }

//   @override
//   void dispose() {
//     _deleteNoteIfTextIsEmpty();
//     _saveNoteIfTextNotEmpty();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create new note"),
//       ),
//       body: FutureBuilder(
//         future: createOrGetExistingNote(context),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               _setupTextControllerListener();
//               return TextField(
//                 controller: _textController,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 decoration: const InputDecoration(hintText: "Enter new note... "),
//               );
//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

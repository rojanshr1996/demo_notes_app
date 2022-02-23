import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/crud/notes_service.dart';
import 'package:demo_app_bloc/utils/generics/get_arguments.dart';
import 'package:flutter/material.dart';

class CreateUpdateNotesScreen extends StatefulWidget {
  final DatabaseNote? note;
  const CreateUpdateNotesScreen({Key? key, this.note}) : super(key: key);

  @override
  State<CreateUpdateNotesScreen> createState() => _CreateUpdateNotesScreenState();
}

class _CreateUpdateNotesScreenState extends State<CreateUpdateNotesScreen> {
  final AuthServices _auth = AuthServices();
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
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
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
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
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    debugPrint(text);
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
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
      appBar: AppBar(
        title: const Text("Create new note"),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Enter new note... "),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

import 'dart:developer';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/firebase_cloud_storage.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/constants.dart';
import 'package:demo_app_bloc/utils/utils.dart';
import 'package:demo_app_bloc/view/notes/color_slider.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

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
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  // Color? color;
  late ValueNotifier<Color> _color;

  // late quill.QuillController _controller = quill.QuillController.basic();
  @override
  void initState() {
    _color = ValueNotifier<Color>(AppColors.cWhite);
    _notesService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _titleControllerListener() async {
    final note = _note;
    debugPrint("$_note");
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text.trim();
    await _notesService.updateNote(documentId: note.documentId, text: text, title: title);
  }

  void _textControllerListener() async {
    log(_textController.text);
    final note = _note;
    debugPrint("$_note");
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text.trim();
    final color = _color.value;
    await _notesService.updateNote(documentId: note.documentId, text: text, title: title, color: "${color.value}");
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    if (widget.note != null) {
      _note = widget.note;
      if (_note?.color != null) {
        _color.value = _note!.color!;
      }
      _titleController.text = widget.note!.title;
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
    final title = _titleController.text.trim();
    final color = _color.value;
    debugPrint(text);
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text, title: title, color: "${color.value}");
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  addImage(BuildContext context) async {
    final result = await Utils.addImage(context);

    if (result != null) {
      log("Selected image: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RemoveFocus(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          shadowColor: Theme.of(context).colorScheme.shadow,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2,
          title: const Text("Create new note"),
          actions: [
            IconButton(
              onPressed: () {
                addImage(context);
              },
              icon: const Icon(Icons.attachment),
            ),
          ],
        ),
        body: SizedBox(
          height: Utilities.screenHeight(context),
          child: FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return ValueListenableBuilder(
                    valueListenable: _color,
                    builder: (context, color, _) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    color == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppColors.cWhite),
                                                  color: _color.value),
                                            ),
                                          ),
                                    SizedBox(width: color == null ? 0 : 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _titleController,
                                        keyboardType: TextInputType.multiline,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: bold),
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          hintText: "Enter title... ",
                                          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.primary, fontWeight: medium),
                                          border: const UnderlineInputBorder(borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _textController,
                                  keyboardType: TextInputType.multiline,
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: regular),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Enter new note... ",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                            child: SizedBox(
                              height: 50,
                              child: ColorSlider(
                                noteColor: _color.value,
                                callBackColorTapped: (color) {
                                  log("SELECTED COLOR: $color");
                                  _color.value = color;
                                  _saveNoteIfTextNotEmpty();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                default:
                  return const Center(child: SimpleCircularLoader());
              }
            },
          ),
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

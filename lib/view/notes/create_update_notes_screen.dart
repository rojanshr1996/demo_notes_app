import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/firebase_cloud_storage.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/constants.dart';
import 'package:demo_app_bloc/utils/utils.dart';
import 'package:demo_app_bloc/view/notes/color_slider.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
  late ValueNotifier<Color> _color;
  late ValueNotifier<File?> _imageFile;
  late ValueNotifier<UploadTask?> _task;
  late ValueNotifier<String> _imageUrl;
  // String _imageUrl = "";

  @override
  void initState() {
    _color = ValueNotifier<Color>(AppColors.cWhite);
    _imageFile = ValueNotifier<File?>(null);
    _task = ValueNotifier<UploadTask?>(null);
    _imageUrl = ValueNotifier<String>("");
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
    await _notesService.updateNote(documentId: note.documentId, text: text, title: title, imageUrl: _imageUrl.value);
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
      log("INITIAL IMAGE: ${_note!.imageUrl}");

      if (_note!.imageUrl != "") {
        if (_imageUrl.value == "" || _imageUrl.value == _note!.imageUrl) {
          _imageUrl.value = _note!.imageUrl!;
          log("PROGRESS: $_imageUrl");
          setState(() {});
        }
      }
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
    if (_textController.text.isEmpty && note != null && _imageUrl.value == "") {
      _notesService.deleteNote(documentId: note.documentId);
      // if (_imageUrl != "") {
      //   _notesService.deleteFile(_imageUrl);
      // }
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text.trim();
    final color = _color.value;

    debugPrint(text);
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
          documentId: note.documentId, text: text, title: title, color: "${color.value}", imageUrl: _imageUrl.value);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    _imageFile.dispose();
    _imageUrl.dispose();
    _color.dispose();
    _task.dispose();
    super.dispose();
  }

  addImage(BuildContext context) async {
    final result = await Utils.addImage(context);

    if (result != null) {
      if (_imageUrl.value != "") {
        _notesService.deleteFile(_imageUrl.value);
      }
      _imageUrl.value = "";
      _saveNoteIfTextNotEmpty();
      _imageFile.value = File(result.path);
      uploadFile();
    }
  }

  // https://firebasestorage.googleapis.com/v0/b/apptest-726c6.appspot.com/o/attachments%2Fimage_picker8372823839918575517.jpg?alt=media&token=ffc45346-01f2-4551-8879-4d3976694684

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
                FocusScope.of(context).unfocus();
                addImage(context);
              },
              icon: const Icon(Icons.photo),
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
                        mainAxisSize: MainAxisSize.min,
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
                          ValueListenableBuilder(
                            valueListenable: _imageFile,
                            builder: (context, imageFile, _) {
                              return _imageFile.value == null || _imageFile.value?.path == null
                                  ? ValueListenableBuilder(
                                      valueListenable: _imageUrl,
                                      builder: (context, imageUrl, _) {
                                        return _imageUrl.value != ""
                                            ? Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        width: 200,
                                                        color: AppColors.cBlueShadow,
                                                        child: CachedNetworkImage(
                                                          imageUrl: _imageUrl.value,
                                                          fit: BoxFit.cover,
                                                          memCacheHeight: 50,
                                                          errorWidget: (context, url, error) => Icon(
                                                            Icons.error,
                                                            color: Theme.of(context).colorScheme.background,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _imageFile.value = null;
                                                          if (_imageUrl.value != "") {
                                                            _notesService.deleteFile(_imageUrl.value);
                                                            _imageUrl.value = "";
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 42,
                                                          width: 200,
                                                          color: AppColors.cRedAccent,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: AppColors.cWhite,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox();
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 150,
                                              width: 200,
                                              color: AppColors.cBlueShadow,
                                              child: Image.file(_imageFile.value!, fit: BoxFit.cover, cacheHeight: 500),
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: _task,
                                              builder: (context, task, _) {
                                                return task != null
                                                    ? buildUploadStatus(_task.value!)
                                                    : const SizedBox();
                                              },
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _imageFile.value = null;
                                                if (_imageUrl.value != "") {
                                                  _notesService.deleteFile(_imageUrl.value);
                                                  _imageUrl.value = "";
                                                }
                                              },
                                              child: Container(
                                                height: 42,
                                                width: 200,
                                                color: AppColors.cRedAccent,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.cWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
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

  Future uploadFile() async {
    if (_imageFile.value == null) return;
    final fileName = basename(_imageFile.value!.path);
    _task.value = _notesService.uploadFile(fileName, _imageFile.value!);
    // setState(() {});

    if (_task.value == null) return;
    final snapshot = await _task.value!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    log("Donwload-link: $urlDownload");
    _imageUrl.value = urlDownload;
    _saveNoteIfTextNotEmpty();
  }
}

Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          // final percentage = (progress * 100).toStringAsFixed(2);
          log("PROGRESS: $progress");
          return Container(
            width: 200,
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.cWhite,
              color: AppColors.cGreen,
              minHeight: 10,
            ),
          );
        } else {
          return Container(height: 10, width: 200, color: AppColors.cWhite);
        }
      },
    );


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

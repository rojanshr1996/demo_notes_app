import 'package:demo_app_bloc/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "You cannot share empty note!",
    optionsBuilder: () => {"OK": null},
  );
}

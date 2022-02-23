import 'package:demo_app_bloc/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure you want to log out?",
    optionsBuilder: () => {"Cancel": false, "Log out": true},
  ).then((value) => value ?? false);
}

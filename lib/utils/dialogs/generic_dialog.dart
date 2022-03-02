import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.cDarkBlue,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.cLight),
        ),
        content: Text(
          content,
          style: const TextStyle(color: AppColors.cLightShade),
        ),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Utilities.returnDataCloseActivity(context, value);
              } else {
                Utilities.closeActivity(context);
              }
            },
            child: Text(
              optionTitle,
              style: const TextStyle(color: AppColors.cLightShade),
            ),
          );
        }).toList(),
      );
    },
  );
}

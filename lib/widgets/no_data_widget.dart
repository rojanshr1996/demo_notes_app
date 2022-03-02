import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final TextStyle textStyle;

  const NoDataWidget({
    Key? key,
    required this.title,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.cDarkBlueLight,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RefreshNoData extends StatelessWidget {
  final String title;
  final TextStyle textStyle;

  const RefreshNoData({
    Key? key,
    required this.title,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.cDarkBlue),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(),
        NoDataWidget(
          title: title,
          textStyle: textStyle,
        ),
      ],
    );
  }
}

import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const NoDataWidget({
    Key? key,
    required this.title,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor);
    return Center(
      child: Text(
        title,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RefreshNoData extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const RefreshNoData({
    Key? key,
    required this.title,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor);
    return Stack(
      children: [
        ListView(),
        NoDataWidget(
          title: title,
          textStyle: style,
        ),
      ],
    );
  }
}

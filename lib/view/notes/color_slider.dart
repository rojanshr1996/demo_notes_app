import 'package:flutter/material.dart';

class ColorSlider extends StatefulWidget {
  final void Function(Color)? callBackColorTapped;
  final Color noteColor;

  const ColorSlider({Key? key, this.callBackColorTapped, required this.noteColor}) : super(key: key);
  @override
  _ColorSliderState createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider> {
  final colors = const [
    Color.fromARGB(255, 255, 255, 255), // classic white
    Color.fromARGB(255, 189, 93, 85),
    Color.fromARGB(255, 202, 157, 7),
    Color.fromARGB(255, 238, 230, 85),
    Color.fromARGB(255, 186, 243, 116),
    Color.fromARGB(255, 126, 235, 211),
    Color.fromARGB(255, 156, 223, 238),
    Color.fromARGB(255, 124, 152, 202),
    Color.fromARGB(255, 185, 137, 228),
    Color.fromARGB(255, 223, 146, 191),
    Color.fromARGB(255, 196, 164, 129),
    Color.fromARGB(255, 190, 191, 194),
    Color.fromARGB(255, 47, 67, 126),
    Color.fromARGB(255, 26, 59, 51),
    Color.fromARGB(255, 103, 50, 202),
    Color.fromARGB(255, 212, 17, 17),
    Color.fromARGB(255, 0, 0, 0),
  ];

  final Color borderColor = const Color(0xffd3d3d3);
  final Color foregroundColor = const Color(0xff595959);

  final _check = const Icon(Icons.check);

  late int indexOfCurrentColor;
  late Color noteColor;
  @override
  void initState() {
    super.initState();
    noteColor = widget.noteColor;
    indexOfCurrentColor = colors.indexOf(widget.noteColor);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: List.generate(
        colors.length,
        (index) {
          return GestureDetector(
            onTap: () {
              if (widget.callBackColorTapped != null) {
                widget.callBackColorTapped!(colors[index]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Container(
                child: CircleAvatar(
                  child: _checkOrNot(index),
                  foregroundColor: foregroundColor,
                  backgroundColor: colors[index],
                ),
                width: 38.0,
                height: 38.0,
                padding: const EdgeInsets.all(1.0), // border width
                decoration: BoxDecoration(
                    color: borderColor, // border color
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5, color: borderColor)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? _checkOrNot(int index) {
    if (indexOfCurrentColor == index) {
      return _check;
    }
    return null;
  }
}

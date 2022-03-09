import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';

class EnlargeImage extends StatelessWidget {
  final ImageArgs imageArgs;

  const EnlargeImage({Key? key, required this.imageArgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _transformationController = TransformationController();
    TapDownDetails? _doubleTapDetails;

    void _handleDoubleTapDown(TapDownDetails details) {
      _doubleTapDetails = details;
    }

    void _handleDoubleTap() {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails?.localPosition;
        _transformationController.value = Matrix4.identity()
          ..translate(-position!.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cBlack,
        body: Stack(
          children: [
            Hero(
              tag: imageArgs.imageUrl,
              child: GestureDetector(
                onDoubleTap: _handleDoubleTap,
                onDoubleTapDown: _handleDoubleTapDown,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: true, // Set it to false to prevent panning.
                  minScale: 1,
                  maxScale: 3,
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: CachedNetworkImage(
                      memCacheHeight: 1500,
                      filterQuality: FilterQuality.none,
                      imageUrl: imageArgs.imageUrl,
                      placeholder: (context, url) => const Center(child: SimpleCircularLoader()),
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, color: AppColors.cBlueAccent, size: 100),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 15,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration:
                      BoxDecoration(color: AppColors.cWhite.withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: BackButton(
                      onPressed: () {
                        Utilities.closeActivity(context);
                      },
                      color: AppColors.cBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

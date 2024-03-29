library custom_ratio_camera;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

typedef OnCropDataCallback = void Function(
  int dx,
  int dy,
  int w,
  int h,
);

// ignore: must_be_immutable
class CustomRatioCameraPreview extends StatefulWidget {
  /// The expected aspect ration
  ///
  late double expectedRatio;

  /// the camera controller
  final CameraController cameraController;

  /// This is the callback function to get cropping parameters
  ///
  ///[dx] and [dy] specify the top left corner of the output rectangle
  ///
  /// [w] is the width of the output rectangle
  ///
  /// [h] is the height of the output rectangle
  ///
  ///
  /// example: ``` ffmpeg -i in.mp4 -filter:v "crop=w:h:dx:dy" out.mp4 ```
  final void Function(
    int dx,
    int dy,
    int w,
    int h,
  )? onCropData;
  CustomRatioCameraPreview({
    Key? key,
    double? expectedRatio,
    required this.cameraController,
    this.onCropData,
  }) : super(key: key) {
    if (expectedRatio != null) {
      this.expectedRatio = expectedRatio;
    } else {
      this.expectedRatio = cameraController.value.aspectRatio;
    }
  }

  @override
  State<CustomRatioCameraPreview> createState() =>
      _CustomRatioCameraPreviewState();
}

class _CustomRatioCameraPreviewState extends State<CustomRatioCameraPreview> {
  ///
  late double cameraH;
  late double cameraW;
  late double pageH;
  late double remainingSpace;
  late double blackedZone;
  late double realSizeCoef;
  Color bgColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        int dx = 0;
        int dy = ((blackedZone / 2) * realSizeCoef).toInt();
        int w = (cameraW * realSizeCoef).toInt();
        int h = ((cameraH - blackedZone) * realSizeCoef).toInt();

        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          dx = blackedZone ~/ 2;
          dy = 0;
          w = ((cameraW - blackedZone) * realSizeCoef).toInt();
          h = (cameraH * realSizeCoef).toInt();
        }
        if (widget.onCropData != null) {
          widget.onCropData!(dx, dy, w, h);
        }
      },
    );
    return LayoutBuilder(builder: (ctx, constraints) {
      return getDefaultCameraPreview(widget.cameraController,
          h: constraints.maxHeight, w: constraints.maxWidth);
    });
  }

  Widget buildLanscapeCamera(
      BuildContext context, CameraController cameraController,
      {required double h, required double w}) {
    var camera = cameraController.value;
    // fetch screen size
    final size = Size(w, h);
    double padding = 0;

    cameraH = size.height;
    cameraW = size.height / (1 / camera.aspectRatio);

    double pageW = size.width;
    remainingSpace = pageW - cameraW;
    padding = remainingSpace / 2;
    if (padding < 0) {
      padding = -padding;
    }

    blackedZone = cameraW - widget.expectedRatio * cameraH;
    if (blackedZone < 0) {
      blackedZone = -blackedZone;
    }
    realSizeCoef = camera.previewSize!.height / cameraH;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: padding),
          child: CameraPreview(
            cameraController,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: padding),
          child: SizedBox(
            height: cameraH,
            width: cameraW,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: cameraH,
                  width: cameraW,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        width: blackedZone / 2,
                        color: bgColor,
                      ),
                      right: BorderSide(
                        width: blackedZone / 2,
                        color: bgColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getDefaultCameraPreview(CameraController cameraController,
      {required double h, required double w}) {
    var camera = cameraController.value;
    // fetch screen size
    final size = Size(w, h);
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return buildLanscapeCamera(context, cameraController, h: h, w: w);
    }

    double padding = 0;

    cameraH = size.width / (1 / camera.aspectRatio);
    cameraW = size.width;
    pageH = size.height;
    remainingSpace = pageH - cameraH;
    padding = remainingSpace / 2;
    if (padding < 0) {
      padding = -padding;
    }

    blackedZone = cameraH - (cameraW / widget.expectedRatio);
    if (blackedZone < 0) {
      blackedZone = -blackedZone;
    }
    realSizeCoef = camera.previewSize!.width / cameraH;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: padding),
          child: CameraPreview(cameraController),
        ),
        Padding(
          padding: EdgeInsets.only(top: padding),
          child: SizedBox(
            height: cameraH,
            width: cameraW,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: cameraH,
                  width: cameraW,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: blackedZone / 2,
                        color: bgColor,
                      ),
                      bottom: BorderSide(
                        width: blackedZone / 2,
                        color: bgColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

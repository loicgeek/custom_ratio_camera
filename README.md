<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This package allow you to have a custom ratio for camera preview using the <a href="https://pub.dev/packages/camera">  camera </a> package, you can the have a square camera preview as you need.

## Features

- A CustomRatioCameraPreview widget
- A callback function that will give you you all necessary informations to perform cropping

## Getting started
- Install this package  ` flutter pub add custom_ratio_camera `
- Follow the <a href="https://pub.dev/packages/camera"> installation steps </a> of the camera package

## Usage



```dart

  /// onCropData function to get cropping parameters
  ///
  ///[dx] and [dy] specify the top left corner of the output rectangle
  ///
  /// [w] is the width of the output rectangle
  ///
  /// [h] is the height of the output rectangle
  ///
  ///
  /// example: ``` ffmpeg -i in.mp4 -filter:v "crop=w:h:dx:dy" out.mp4 ```
  return CustomRatioCameraPreview(
       cameraController: cameraController,
       expectedRatio: 1/1,
       onCropData: (dx, dy, w, h) {
         print(dx);
         print(dy);
         print(h);
         print(w);
       },
     );
```

<div style="position:center">
    <img src='https://github.com/loicgeek/custom_ratio_camera/raw/main/imgs/1_1.jpg' width="200">
    <hr>
    <img src='https://github.com/loicgeek/custom_ratio_camera/raw/main/imgs/9_16.jpg' width="200">
    <hr>
    <img src='https://github.com/loicgeek/custom_ratio_camera/raw/main/imgs/16_9.jpg' width="200">
   

## Additional information

This package does not handle the cropping part, you will have to handle cropping using tools like ffmpeg


## Credits

<a href="https://github.com/loicgeek">Loic NGOU </a>
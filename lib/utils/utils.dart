import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringUtils on String {
  String getPath() {
    return "https://alakhcar.com/uploads/$this";
  }

  String getBaseUrl() {
    return "https://alakhcar.com/api/$this";
  }
}

extension ImageTool on ImageProvider {
  Future<Uint8List?> getBytes(BuildContext context,
      {ImageByteFormat format = ImageByteFormat.rawRgba}) async {
    final imageStream = resolve(createLocalImageConfiguration(context));
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener(
      (imageInfo, synchronousCall) async {
        final bytes = await imageInfo.image.toByteData(format: format);
        if (!completer.isCompleted) {
          completer.complete(bytes?.buffer.asUint8List());
        }
      },
    );
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}
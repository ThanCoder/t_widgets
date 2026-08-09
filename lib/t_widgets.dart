library;

import 'dart:io';

import 'package:flutter/widgets.dart';

export 'src/old_widgets/index.dart';
export 'src/news/index.dart';
export 'src/extensions/index.dart';

typedef CustomDownloadImageCallback =
    Future<void> Function(
      String url,
      String savePath, {
      void Function(double progress)? onProgress,
      void Function(String error)? onError,
    });
typedef OpenImageFileChooserCallback =
    Future<String?> Function({String? initialDirectory});
typedef OnFileChooserGetCoverPath =
    Future<String> Function(FileSystemEntity file);
typedef ImageCachePathCallback = String Function(String url, String cacheName);

class TWidgets {
  static final TWidgets instance = TWidgets._();
  TWidgets._();
  factory TWidgets() => instance;

  String? defaultImageAssetsPath;
  static bool isDebugPrint = true;
  CustomDownloadImageCallback? onCustomDownloadImage;
  bool Function()? isDarkTheme;
  OpenImageFileChooserCallback? onOpenImageFileChooser;
  OnFileChooserGetCoverPath? onFileChooserGetCoverPath;
  ImageCachePathCallback? getCachePath;

  Future<void> init({
    required String defaultImageAssetsPath,
    bool isDebugPrint = true,
    CustomDownloadImageCallback? onCustomDownloadImage,
    bool Function()? isDarkTheme,
    OpenImageFileChooserCallback? onOpenImageFileChooser,
    OnFileChooserGetCoverPath? onFileChooserGetCoverPath,

    ///
    /// all `TImageCache` path
    ///
    ImageCachePathCallback? getCachePath,
  }) async {
    isDebugPrint = isDebugPrint;
    this.defaultImageAssetsPath = defaultImageAssetsPath;
    this.onCustomDownloadImage = onCustomDownloadImage;
    this.isDarkTheme = isDarkTheme;
    this.onOpenImageFileChooser = onOpenImageFileChooser;
    this.onFileChooserGetCoverPath = onFileChooserGetCoverPath;
    this.getCachePath = getCachePath;

    await Future.delayed(Duration.zero);
  }

  static void showDebugLog(String msg, {String? tag}) {
    if (isDebugPrint) {
      if (tag != null) {
        debugPrint('[$tag]: $msg');
        return;
      }
      debugPrint(msg);
    }
  }

  static String get getOnDownloadImageErrorText {
    return '''await TWidgets.instance.init''';
  }
}

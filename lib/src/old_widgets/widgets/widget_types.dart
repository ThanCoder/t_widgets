import 'package:material_ui/material_ui.dart';

typedef FrameBuilderCallback =
    Widget Function(
      BuildContext context,
      Widget widget,
      int? frame,
      bool wasSynchronouslyLoaded,
    );
typedef LoadingBuilderCallback =
    Widget Function(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    );
typedef ErrorBuilderCallback =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

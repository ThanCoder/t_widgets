import 'package:material_ui/material_ui.dart';

extension NavigatorContext on BuildContext {
  /// ### Pop Route
  /// Pop the top-most route off the navigator that most tightly encloses the given context.
  void pop<T extends Object?>([T? result]) async {
    Navigator.pop<T>(this, result);
  }

  /// ### push material page route
  Future<T?> pushMaterialPageRoute<T extends Object?>({
    required Widget Function(BuildContext mainCtx) builder,
    RouteSettings? settings,
    bool? requestFocus,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    TraversalEdgeBehavior? directionalTraversalEdgeBehavior,
  }) async {
    return await Navigator.push<T>(
      this,
      MaterialPageRoute(
        builder: builder,
        settings: settings,
        requestFocus: requestFocus,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        traversalEdgeBehavior: traversalEdgeBehavior,
        directionalTraversalEdgeBehavior: directionalTraversalEdgeBehavior,
      ),
    );
  }
}

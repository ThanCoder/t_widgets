import 'package:material_ui/material_ui.dart';

extension ContextExt on BuildContext {
  /// app brightness
  Brightness get brightness => Theme.brightnessOf(this);

  bool get isDarkMode => brightness == .dark;

  bool get isLightMode => brightness == .light;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The current brightness mode of the host platform.
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  /// Whether the device is inverting the colors of the platform.
  bool get invertColors => MediaQuery.of(this).invertColors;

  ///The orientation of the media (e.g., whether the device is in landscape or portrait mode)
  Orientation get orientation => MediaQuery.of(this).orientation;

  // void (){
  //   Theme.of(this).
  // }
}

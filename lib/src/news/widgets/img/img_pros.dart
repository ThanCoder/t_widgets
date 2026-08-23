// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:material_ui/material_ui.dart';

class ImgPros {
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final int? cacheWidth;
  final int? cacheHeight;
  final double scale; // = 1.0;
  final bool excludeFromSemantics; // = false;
  final AlignmentGeometry alignment; // = Alignment.center;
  final ImageRepeat repeat; // = ImageRepeat.noRepeat;
  final Rect? centerSlice;
  final bool matchTextDirection; // = false;
  final bool gaplessPlayback; // = false;
  final bool isAntiAlias; // = false;
  final FilterQuality filterQuality; // = FilterQuality.medium;
  const ImgPros({
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.centerSlice,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.medium,
  });
}

import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:t_widgets/src/news/widgets/img/img_pros.dart';

class TImgFile extends StatelessWidget {
  final File file;
  final ImgPros props;
  const TImgFile({super.key, required this.file, this.props = const ImgPros()});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      key: key,
      alignment: props.alignment,
      cacheHeight: props.cacheHeight,
      cacheWidth: props.cacheWidth,
      centerSlice: props.centerSlice,
      color: props.color,
      colorBlendMode: props.colorBlendMode,
      errorBuilder: props.errorBuilder,
      excludeFromSemantics: props.excludeFromSemantics,
      filterQuality: props.filterQuality,
      fit: props.fit,
      frameBuilder: props.frameBuilder,
      gaplessPlayback: props.gaplessPlayback,
      height: props.height,
      isAntiAlias: props.isAntiAlias,
      matchTextDirection: props.matchTextDirection,
      opacity: props.opacity,
      repeat: props.repeat,
      scale: props.scale,
      semanticLabel: props.semanticLabel,
      width: props.width,
    );
  }
}

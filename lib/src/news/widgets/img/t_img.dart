import 'package:material_ui/material_ui.dart';
import 'package:t_widgets/src/news/widgets/img/img_pros.dart';
import 'package:t_widgets/src/news/widgets/img/t_img_controller.dart';

class TImg extends StatelessWidget {
  final ImgPros props;
  final TImgController controller;
  const TImg({
    super.key,
    this.props = const ImgPros(),
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Image(
          image: controller.source.provider,
          errorBuilder: props.errorBuilder,
        );
      },
    );
  }
}



/*
alignment: props.alignment,
      centerSlice: props.centerSlice,
      color: props.color,
      colorBlendMode: props.colorBlendMode,
      
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
      semanticLabel: props.semanticLabel,
      width: props.width,
*/
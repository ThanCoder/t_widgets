import 'package:material_ui/material_ui.dart';
import 'package:t_widgets/src/news/widgets/img/t_img_source.dart';

class TImgController extends ChangeNotifier {
  TImgSource _source;
  TImgController(this._source);

  TImgSource get source => _source;

  void setSource(TImgSource source) {
    if (_source == source) return;
    
    _source = source;
    notifyListeners();
  }
}

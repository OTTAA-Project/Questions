import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends ChangeNotifier {
  double left = 0, top = 0;
  bool isListening = false;
  String text = '';
  double confidence = 1.0;

  void initialPosition(double left, double top) {
    this.left = left;
    this.top = top;
    notifyListeners();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    left = details.localPosition.dx;
    top = details.localPosition.dy;
    notifyListeners();
  }
}

final homeProvider = ChangeNotifierProvider<HomeProvider>((ref) {
  return HomeProvider();
});

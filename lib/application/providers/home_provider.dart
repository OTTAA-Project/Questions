import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends ChangeNotifier {
  double left = 0, top = 0;
  bool isListening = false;
  String text = '';
  double confidence = 1.0;
}

final homeProvider = ChangeNotifierProvider<HomeProvider>((ref) {
  return HomeProvider();
});

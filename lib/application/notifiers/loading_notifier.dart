import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void showLoading() => state = true;

  void hideLoading() => state = false;

  void toggleLoading() => state = !state;

  bool get isLoading => state;
}

final loadingNotifier = StateNotifierProvider<LoadingNotifier, bool>(
  (ref) => LoadingNotifier(),
);

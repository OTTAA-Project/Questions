import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Injector extends StatelessWidget {
  final Widget app;

  const Injector({super.key, required this.app}) : super();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: app,
    );
  }
}

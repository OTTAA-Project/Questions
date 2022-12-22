import 'package:flutter/material.dart';

class AnimatedDialog {
  static Future<T?> animate<T>(BuildContext context, Widget builder) {
    final theme = Theme.of(context);
    return showGeneralDialog<T>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(CurveTween(curve: Curves.easeInOut)),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: Container(
            decoration: ShapeDecoration(
              color: theme.colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: builder,
          ),
        );
      },
    );
  }
}

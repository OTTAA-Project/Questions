import 'package:flutter/material.dart';
import 'package:questions_by_ottaa/application/router/app_router.dart';
import 'package:questions_by_ottaa/presentation/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Application extends StatelessWidget {
  const Application({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          routerConfig: router,
          title: "Questions by Ottaa",
          theme: kAppTheme,
        );
      },
    );
  }
}

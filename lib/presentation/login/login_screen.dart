import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:questions_by_ottaa/application/notifiers/loading_notifier.dart';
import 'package:questions_by_ottaa/application/providers/providers.dart';
import 'package:questions_by_ottaa/presentation/common/ui/jumping_dots.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingNotifier);
    final auth = ref.watch(authProvider);

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ottaa_logo_drawer.png', width: (size.width / 3)),
            const SizedBox(height: 20),
            Text('Bienvenido', style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Regístrate con tu cuenta de Google para acceder a todas las funciones de la aplicación',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium!.copyWith(color: Colors.white60, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () async {
                ref.watch(loadingNotifier.notifier).toggleLoading();
                final result = await auth.signIn();
                ref.watch(loadingNotifier.notifier).toggleLoading();
                result.fold(
                  (left) => {
                    //TODO: show error
                  },
                  (right) {
                    context.go('/splash');
                  },
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: loading
                    ? const Center(child: JumpingDotsProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            child: Image.asset('assets/images/gIcon.png'),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            flex: 4,
                            child: Text(
                              'Acceder con Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

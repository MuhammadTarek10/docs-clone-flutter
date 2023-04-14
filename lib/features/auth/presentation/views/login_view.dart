import 'package:docs/config/routes.dart';
import 'package:docs/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final snackbar = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final user = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (user != null) {
      ref.read(userProvider.notifier).update((state) => user);
      snackbar.showSnackBar(
        const SnackBar(
          content: Text("Logged In"),
        ),
      );
      navigator.replace(Routes.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: Image.asset('assets/images/g-logo-2.png'),
          label: const Text(
            "Sign in With Google",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            maximumSize: const Size(250, 50),
          ),
        ),
      ),
    );
  }
}

import 'package:docs/features/auth/data/repositories/auth_repository.dart';
import 'package:docs/features/docs/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final user = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (user != null) {
      ref.read(userProvider.notifier).update((state) => user);
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Logged In"),
        ),
      );
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
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

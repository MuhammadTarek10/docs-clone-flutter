import 'package:docs/features/auth/data/models/user_model.dart';
import 'package:docs/features/auth/data/repositories/auth_repository.dart';
import 'package:docs/features/auth/presentation/views/login_view.dart';
import 'package:docs/features/docs/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    user = await ref.read(authRepositoryProvider).getUserData();
    if (user != null) {
      ref.read(userProvider.notifier).update((state) => user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: isUser != null ? const HomeView() : const LoginView(),
    );
  }
}

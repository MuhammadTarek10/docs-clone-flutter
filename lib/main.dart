import 'package:docs/config/routes.dart';
import 'package:docs/features/auth/data/models/user_model.dart';
import 'package:docs/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final isUser = ref.watch(userProvider);
        if (isUser != null && isUser.token.isNotEmpty) {
          return Routes.app;
        }
        return Routes.login;
      }),
    );
  }
}

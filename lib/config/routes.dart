import 'package:docs/features/auth/presentation/views/login_view.dart';
import 'package:docs/features/docs/presentation/views/document_view.dart';
import 'package:docs/features/docs/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class Routes {
  static const String baseRoute = "/";
  static const String loginRoute = "/";
  static const String homeRoute = "/";
  static const String documentRoute = "/docs";

  static const String document = "/docs/:id";

  static RouteMap base = RouteMap(routes: {
    baseRoute: (_) => const Redirect(loginRoute),
  });

  static RouteMap login = RouteMap(routes: {
    loginRoute: (_) => const MaterialPage(child: LoginView()),
  });

  static RouteMap app = RouteMap(routes: {
    homeRoute: (_) => const MaterialPage(child: HomeView()),
    document: (route) =>
        MaterialPage(child: DocumentView(id: route.pathParameters['id']!)),
  });
}

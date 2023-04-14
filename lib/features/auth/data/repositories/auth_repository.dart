import 'dart:convert';
import 'dart:developer' show log;

import 'package:docs/config/apis.dart';
import 'package:docs/features/auth/data/datasource/local_datasource.dart';
import 'package:docs/features/auth/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorage: LocalStorage(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorage _localStorage;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorage localStorage,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorage = localStorage;

  Future<UserModel?> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
          name: user.displayName!,
          email: user.email,
          photoUrl: user.photoUrl!,
          uid: "",
          token: "",
        );
        final res = await _client.post(
          Uri.parse(Apis.login),
          body: jsonEncode(userAccount.toJson()),
          headers: Apis.baseHeaders,
        );
        switch (res.statusCode) {
          case 200:
            final newUser = userAccount.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            _localStorage.setToken(newUser.token);
            return newUser;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _localStorage.setToken("");
  }

  Future<UserModel?> getUserData() async {
    try {
      final String? token = await _localStorage.getToken();
      if (token != null) {
        Apis.setToken(token);
        final res = await _client.get(
          Uri.parse(Apis.getData),
          headers: Apis.headersWithToken,
        );
        switch (res.statusCode) {
          case 200:
            return UserModel.fromJson(
              jsonDecode(res.body)['user'],
            ).copyWith(token: token);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}

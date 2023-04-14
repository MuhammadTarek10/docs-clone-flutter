import 'dart:convert';
import 'dart:developer';

import 'package:docs/config/apis.dart';
import 'package:docs/features/auth/data/datasource/local_datasource.dart';
import 'package:docs/features/docs/data/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    localStorage: LocalStorage(),
    client: Client(),
  ),
);

class DocumentRepository {
  final LocalStorage _localStorage;
  final Client _client;

  DocumentRepository({
    required LocalStorage localStorage,
    required Client client,
  })  : _localStorage = localStorage,
        _client = client;

  Future<DocumentModel?> createDocument() async {
    try {
      final String? token = await _localStorage.getToken();
      Apis.setToken(token!);
      final res = await _client.post(
        Uri.parse(Apis.createDocument),
        headers: Apis.headersWithToken,
        body: jsonEncode({
          'createdAt': DateTime.now().microsecondsSinceEpoch,
        }),
      );
      switch (res.statusCode) {
        case 200:
          return DocumentModel.fromJson(
            jsonDecode(res.body)['document'],
          );
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void updateDocumentTitle(String id, String title) async {
    try {
      final String? token = await _localStorage.getToken();
      Apis.setToken(token!);
      await _client.post(
        Uri.parse(Apis.updateDocumentTitle),
        headers: Apis.headersWithToken,
        body: jsonEncode({
          "id": id,
          "title": title,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<DocumentModel?> getDocument(String id) async {
    try {
      final String? token = await _localStorage.getToken();
      Apis.setToken(token!);
      final res = await _client.get(
        Uri.parse("${Apis.docs}/$id"),
        headers: Apis.headersWithToken,
      );
      switch (res.statusCode) {
        case 200:
          return DocumentModel.fromJson(
            jsonDecode(res.body)['document'],
          );
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<DocumentModel?>> getDocuments() async {
    try {
      final String? token = await _localStorage.getToken();
      Apis.setToken(token!);
      final res = await _client.get(
        Uri.parse(Apis.getAllDocuments),
        headers: Apis.headersWithToken,
      );
      switch (res.statusCode) {
        case 200:
          return (jsonDecode(res.body)['documents'] as List)
              .map((e) => DocumentModel.fromJson(e))
              .toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}

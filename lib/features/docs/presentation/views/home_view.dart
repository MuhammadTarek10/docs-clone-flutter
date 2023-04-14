import 'package:docs/config/routes.dart';
import 'package:docs/features/auth/data/repositories/auth_repository.dart';
import 'package:docs/features/docs/data/models/document_model.dart';
import 'package:docs/features/docs/data/repositories/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void signOut(WidgetRef ref) async {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final DocumentModel? doc =
        await ref.read(documentRepositoryProvider).createDocument();
    if (doc != null) {
      navigator.push("${Routes.documentRoute}/${doc.id}");
    } else {
      snackbar.showSnackBar(
        const SnackBar(
          content: Text("Error In Creating Document, Try Again Later"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void goToDocument(BuildContext context, String id) {
    Routemaster.of(context).push("${Routes.documentRoute}/$id");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => createDocument(context, ref),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentModel?>>(
        future: ref.watch(documentRepositoryProvider).getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.requireData.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final DocumentModel? doc = snapshot.requireData[index];
                return InkWell(
                  onTap: () => goToDocument(context, doc.id),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    height: 50,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Center(
                        child: Text(doc!.title),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

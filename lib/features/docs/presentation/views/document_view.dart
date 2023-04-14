import 'dart:async';

import 'package:docs/config/apis.dart';
import 'package:docs/features/docs/data/models/document_model.dart';
import 'package:docs/features/docs/data/repositories/document_repository.dart';
import 'package:docs/features/docs/data/repositories/socket_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  const DocumentView({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  final TextEditingController titleController = TextEditingController();
  DocumentModel? documentModel;
  SocketRepository socketRepository = SocketRepository();
  quill.QuillController? _controller = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    getDocumentData();
    socketRepository.changeLister((data) => {
          _controller?.compose(
            quill.Delta.fromJson(data['delta']),
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            quill.ChangeSource.REMOTE,
          ),
        });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void getDocumentData() async {
    documentModel =
        await ref.read(documentRepositoryProvider).getDocument(widget.id);

    if (documentModel != null) {
      titleController.text = documentModel!.title;
      _controller = quill.QuillController(
        document: documentModel!.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(documentModel!.content),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }

    _controller!.document.changes.listen((event) {
      if (event.source == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> content = {
          "delta": event.change,
          "documentId": widget.id,
        };
        socketRepository.typing(content);
      }
    });
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateDocumentTitle(widget.id, title);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(
                        ClipboardData(text: '${Apis.docs}/${widget.id}'))
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Link copied!',
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.lock,
                size: 16,
              ),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Routemaster.of(context).replace('/');
                },
                child: Image.asset(
                  'assets/images/docs-logo.png',
                  height: 40,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade800,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            quill.QuillToolbar.basic(controller: _controller!),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller!,
                      readOnly: false,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

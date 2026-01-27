import 'package:flutter/material.dart';

Future<void> showTextEditorSheet(
    BuildContext context, {
      required String title,
      required TextEditingController targetController,
      int maxLines = 8,
    }) async {
  // ✅ Local controller (prevents "used after dispose")
  final local = TextEditingController(text: targetController.text);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _TextEditorSheet(
        title: title,
        localController: local,
        maxLines: maxLines,
        onSave: () {
          // ✅ Write back safely
          if (targetController.hasListeners || targetController.text.isNotEmpty || true) {
            // even if targetController was disposed, this assignment can throw
            // so we guard with try/catch
            try {
              targetController.text = local.text;
            } catch (_) {
              // ignore if controller is disposed
            }
          }
          Navigator.of(ctx).pop();
        },
      );
    },
  );

  local.dispose();
}

class _TextEditorSheet extends StatelessWidget {
  final String title;
  final TextEditingController localController;
  final int maxLines;
  final VoidCallback onSave;

  const _TextEditorSheet({
    required this.title,
    required this.localController,
    required this.maxLines,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onSave,
                        child: const Text('Done'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: localController,
                    autofocus: true,
                    maxLines: maxLines,
                    minLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
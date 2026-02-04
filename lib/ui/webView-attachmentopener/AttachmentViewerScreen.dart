import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AttachmentViewerScreen extends StatefulWidget {
  final String url;
  const AttachmentViewerScreen({super.key, required this.url});

  @override
  State<AttachmentViewerScreen> createState() => _AttachmentViewerScreenState();
}

class _AttachmentViewerScreenState extends State<AttachmentViewerScreen> {
  late final WebViewController _webController;

  bool get isImage =>
      widget.url.toLowerCase().endsWith(".png") ||
          widget.url.toLowerCase().endsWith(".jpg") ||
          widget.url.toLowerCase().endsWith(".jpeg") ||
          widget.url.toLowerCase().endsWith(".webp");

  bool get isPdf => widget.url.toLowerCase().endsWith(".pdf");

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _handleBack() async {
    if (!isImage && !isPdf) {
      final canGoBack = await _webController.canGoBack();
      if (canGoBack) {
        await _webController.goBack();
        return;
      }
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _handleBack,
        ),
        title: const Text("Attachment", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isImage
          ? _imageViewer()
          : isPdf
          ? _pdfViewer()
          : WebViewWidget(controller: _webController),
    );
  }

  Widget _imageViewer() {
    final cleanUrl = widget.url.replaceAll("//uploads", "/uploads");

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4,
      child: Center(
        child: Image.network(
          cleanUrl,
          fit: BoxFit.contain,
          headers: const {
            "User-Agent":
            "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36",
          },
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.broken_image, color: Colors.red, size: 80),
                SizedBox(height: 10),
                Text("Image not found", style: TextStyle(color: Colors.white)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pdfViewer() {
    return SfPdfViewer.network(
      widget.url,
      canShowScrollStatus: true,
      canShowPaginationDialog: true,
    );
  }
}
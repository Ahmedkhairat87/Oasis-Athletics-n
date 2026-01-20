import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AttachmentViewerScreen extends StatelessWidget {
  final String url;

  const AttachmentViewerScreen({super.key, required this.url});

  bool get isImage =>
      url.toLowerCase().endsWith(".png") ||
      url.toLowerCase().endsWith(".jpg") ||
      url.toLowerCase().endsWith(".jpeg") ||
      url.toLowerCase().endsWith(".webp");

  bool get isPdf => url.toLowerCase().endsWith(".pdf");

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.grey.shade900,
        title: const Text("Attachment"),
        centerTitle: true,
      ),
      body:
          isImage
              ? _imageViewer()
              : isPdf
              ? _pdfViewer()
              : _webViewer(),
    );
  }

  //size
  Widget _imageViewer() {
    final cleanUrl = url.replaceAll("//uploads", "/uploads");

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
      url,
      canShowScrollStatus: true,
      canShowPaginationDialog: true,
    );
  }

  Widget _webViewer() {
    return SizedBox.expand(
      child: WebViewWidget(
        controller:
            WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}

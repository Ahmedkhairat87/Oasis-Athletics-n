import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementGateWebView extends StatefulWidget {
  final String url;
  final String title;

  /// Must return the map that contains requiredFlag/requiredURL
  /// (either whole response or res["data"] depending on your API)
  final Future<Map<String, dynamic>?> Function() fetchRegStd;

  const AgreementGateWebView({
    super.key,
    required this.url,
    required this.title,
    required this.fetchRegStd,
  });

  @override
  State<AgreementGateWebView> createState() => _AgreementGateWebViewState();
}

class _AgreementGateWebViewState extends State<AgreementGateWebView> {
  late final WebViewController _controller;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<bool> _tryClose() async {
    if (_checking) return false;

    setState(() => _checking = true);
    try {
      final res = await widget.fetchRegStd();
      if (!mounted) return false;

      if (res == null) {
        _showSnack('Could not verify agreement status. Please try again.');
        return false;
      }

      final flag = (res["requiredFlag"] ?? "0").toString();

      if (flag == "1") {
        _showSnack('You must accept the agreement before continuing.');
        return false;
      }

      // ✅ flag != 1 => allow close
      return true;
    } catch (_) {
      if (mounted) _showSnack('Error checking status. Please try again.');
      return false;
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canClose = await _tryClose();
        return canClose; // ✅ only pop if allowed
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false, // ✅ remove default back
          actions: [
            TextButton(
              onPressed: _checking
                  ? null
                  : () async {
                final canClose = await _tryClose();
                if (canClose && mounted) Navigator.pop(context);
              },
              child: _checking
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
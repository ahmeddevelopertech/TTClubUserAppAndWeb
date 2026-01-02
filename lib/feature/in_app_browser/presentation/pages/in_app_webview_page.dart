import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewPage extends StatefulWidget {
  final String title;
  final Uri url;

  const InAppWebViewPage({super.key, required this.title, required this.url});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (_) => setState(() => _loading = false),
          onNavigationRequest: (request) async {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;

            // allow only http/https in webview
            if (uri.scheme == 'http' || uri.scheme == 'https') {
              return NavigationDecision.navigate;
            }

            // external schemes (tel/mailto/whatsapp...)
            final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
            return ok ? NavigationDecision.prevent : NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => _controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
        ],
      ),
    );
  }
}

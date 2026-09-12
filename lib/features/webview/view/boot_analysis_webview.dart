import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BootAnalysisWebView extends StatefulWidget {
  const BootAnalysisWebView({super.key});

  @override
  State<BootAnalysisWebView> createState() => _BootAnalysisWebViewState();
}

class _BootAnalysisWebViewState extends State<BootAnalysisWebView> {
  late final WebViewController _controller;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() => _loadingProgress = progress);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://uart-ai-analyzer-322385.hostingersite.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل إقلاع الجهاز'),
      ),
      body: Column(
        children: [
          if (_loadingProgress < 100)
            LinearProgressIndicator(value: _loadingProgress / 100),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}

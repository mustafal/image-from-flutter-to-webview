import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Demo', home: MyWebView());
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewController _controller;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadHtmlFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: WebViewWidget(
                controller: _controller, // Enable JavaScript
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _controller
                    .runJavaScript("displayImage('${_textController.text}')");
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Icon(Icons.arrow_forward),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadHtmlFromAssets() async {
    String fileHtmlContents =
        await DefaultAssetBundle.of(context).loadString("assets/index.html");
    _controller.loadRequest(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }
}

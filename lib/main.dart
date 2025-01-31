import 'dart:convert'; // Provides encoding utilities, required for HTML string conversion

import 'package:flutter/material.dart'; // Core Flutter UI framework
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp()); // Entry point for the Flutter app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget provides the basic app structure and theme
    return MaterialApp(title: 'Demo', home: MyWebView());
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewController
      _controller; // WebView controller to manage web content
  final _textController =
      TextEditingController(); // Controller for text field input

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController and set JavaScript mode to unrestricted
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadHtmlFromAssets(); // Load HTML content from assets
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Default app bar
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        // Consistent padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: WebViewWidget(
                controller:
                    _controller, // WebView widget with assigned controller
              ),
            ),
            const SizedBox(height: 8),
            // TextField for user to input the image URL
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Image URL'),
            ),
            // Button to trigger JavaScript execution in the WebView
            ElevatedButton(
              onPressed: () async {
                // Pass the input URL to the JavaScript function `displayImage()`
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
        // Floating button with no assigned action
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  // Load HTML content from assets and inject it into the WebView
  void _loadHtmlFromAssets() async {
    String fileHtmlContents =
        await DefaultAssetBundle.of(context).loadString("assets/index.html");
    // Load HTML content into WebView using base64 encoding
    _controller.loadRequest(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }
}

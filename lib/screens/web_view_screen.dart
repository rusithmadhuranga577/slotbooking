import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:slotbooking/components/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class WebVIewScreen extends StatefulWidget {
  final String url;
  const WebVIewScreen({super.key, required this.url});

  @override
  _WebVIewScreenState createState() => _WebVIewScreenState();
}

class _WebVIewScreenState extends State<WebVIewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  bool loading = false;

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void injectCss() {
    String styles = ".wd-toolbar{ display: none; }.whb-general-header{ display: none; }";
    webViewController?.injectCSSCode(source: styles);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialSettings: settings,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) async {
                  print('loading start');
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    loading = true;
                  });
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT);
                },
                onLoadStop: (controller, url) async {
                  print('loading stop');
                  pullToRefreshController?.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    loading = false;
                  });
                },
                onReceivedError: (controller, request, error) {
                  setState(() {
                    // loading = false;
                  });
                  pullToRefreshController?.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  injectCss();
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = this.url;
                    loading = false;
                  });
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
              ),
              loading ? LoadingOverlay() : Container()
            ],
          ),
        ),
      ])
      )
    );
  }
}
/*
 * Copyright (c) 2018 Larry Aasen. All rights reserved.
 */

library tweet_webview;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetWebView extends StatefulWidget {
  final String tweetUrl;

  final String tweetID;

  TweetWebView({this.tweetUrl, this.tweetID});

  TweetWebView.tweetID(String tweetID)
      : this.tweetID = tweetID,
        this.tweetUrl = null;
  TweetWebView.tweetUrl(String tweetUrl)
      : this.tweetUrl = tweetUrl,
        this.tweetID = null;

  @override
  _TweetWebViewState createState() => new _TweetWebViewState();
}

class _TweetWebViewState extends State<TweetWebView> {
  String _tweetHTML;
  String _filename;

  @override
  void initState() {
    super.initState();

    _requestTweet();
  }

  @override
  Widget build(BuildContext context) {
    var child;
    if (_tweetHTML != null && _tweetHTML.length > 0) {
      final downloadUrl = Uri.file(_filename).toString();

      // Create the WebView to contian the tweet HTML
      final webView = WebView(
          initialUrl: downloadUrl, javascriptMode: JavascriptMode.unrestricted);

      // The WebView creates an exception: RenderAndroidView object was given an infinite size during layout.
      // To avoid that exception a max height constraint will be used. Hopefully soon the WebView will be able
      // to size itself so it will not have an infinite height.
      final box = LimitedBox(
        maxHeight: 500.0,
        child: webView,
      );

      child = box;
    } else {
      child = Text('Loading...');
    }

    return Container(child: child);
  }

  /// Download the embedded tweet.
  /// See Twitter docs: https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/overview
  void _requestTweet() async {
    String tweetUrl = widget.tweetUrl;
    String tweetID;

    if (tweetUrl == null || tweetUrl.isEmpty) {
      if (widget.tweetID == null || widget.tweetID.isEmpty) {
        throw new ArgumentError('Missing tweetUrl or tweetID property.');
      }
      tweetUrl = _formTweetURL(widget.tweetID);
      tweetID = widget.tweetID;
    }

    if (tweetID == null) {
      tweetID = _tweetIDFromUrl(tweetUrl);
    }

    // Example: https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/463440424141459456
    final downloadUrl = "https://publish.twitter.com/oembed?url=$tweetUrl";
    print("TweetWebView._requestTweet: $downloadUrl");

    final jsonString = await _loadTweet(downloadUrl);
    final html = _parseTweet(jsonString);
    if (html != null) {
      final filename = await _saveTweetToFile(tweetID, html);
      setState(() {
        _tweetHTML = html;
        _filename = filename;
      });
    }
  }

  String _tweetIDFromUrl(String tweetUrl) {
    final uri = Uri.parse(tweetUrl);
    if (uri.pathSegments.length > 0) {
      return uri.pathSegments[uri.pathSegments.length - 1];
    }
    return null;
  }

  String _formTweetURL(String tweetID) {
    return "https://twitter.com/Interior/status/$tweetID";
  }

  Future<String> _saveTweetToFile(String tweetID, String html) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final filename = '$tempPath/tweet-$tweetID.html';
    File(filename).writeAsString(html);
    return filename;
  }

  String _parseTweet(String jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      print('TweetWebView._parseTweet: empty jsonString');
      return null;
    }

    var item;
    try {
      item = json.decode(jsonString);
    } catch (e) {
      print(e);
      print('error parsing tweet json: $jsonString');
      return '<p>error loading tweet</p>';
    }

    final String html = item['html'];

    if (html == null || html.isEmpty) {
      print('TweetWebView._parseTweet: empty html');
    }

    return html;
  }

  Future<String> _loadTweet(String tweetUrl) async {
    http.Response result = await _downloadTweet(tweetUrl);

    return result.body;
  }

  Future<http.Response> _downloadTweet(String tweetUrl) {
    return http.get(tweetUrl);
  }
}

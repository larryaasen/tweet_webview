library tweet_webview;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetWebView extends StatefulWidget {
  final String tweetUrl;

  TweetWebView({this.tweetUrl});

  @override
  _TweetWebViewState createState() => new _TweetWebViewState();
}

class _TweetWebViewState extends State<TweetWebView> {
  String _tweetHTML;

  @override
  void initState() {
    super.initState();

    _requestTweet();
  }

  @override
  Widget build(BuildContext context) {
    var child;
    if (_tweetHTML != null && _tweetHTML.length > 0) {
      final downloadUrl = "https://publish.twitter.com/oembed?url=${widget.tweetUrl}";

      final webView = WebView(
        initialUrl: downloadUrl,
        javaScriptMode: JavaScriptMode.unrestricted,
      );
      child = webView;
    } else {
      child = Text('Loading...');
    }

    return Container(child: child);
  }

  /// Download the embedded tweet.
  /// See Twitter docs: https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/overview
  void _requestTweet() async {
    if (widget.tweetUrl == null || widget.tweetUrl.length == 0) {
      throw new ArgumentError('Invalid tweetUrl $this.tweetUrl.');
    }

    // Example: https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/463440424141459456
    final downloadUrl = "https://publish.twitter.com/oembed?hide_media=true&hide_thread=true&url=${widget.tweetUrl}";
    print("TweetWebView._requestTweet: $downloadUrl");

    final jsonString = await _loadTweet(downloadUrl);
    _parseTweet(jsonString);
  }

  void _parseTweet(String jsonString) async {
    if (jsonString == null || jsonString.length == 0) {
      print('TweetWebView._parseTweet: empty jsonString');
      return;
    }

    final item = json.decode(jsonString);

    final String html = item['html'];

    if (html != null && html.length > 0) {
      setState(() {
        _tweetHTML = html;
      });
    } else {
      print('TweetWebView._parseTweet: empty html');
    }
  }

  Future<String> _loadTweet(String tweetUrl) async {
    final startDate = DateTime.now();

    // Download the feed
    http.Response result = await _downloadTweet(tweetUrl);

    final endDate = DateTime.now();
    final diff = endDate.difference(startDate);
    final msec = diff.inMilliseconds;

    print("TweetWebView._loadTweet: code: ${result.statusCode}, completed in $msec msecs");

    return result.body;
  }

  Future<http.Response> _downloadTweet(String tweetUrl) {
    return http.get(tweetUrl);
  }
}

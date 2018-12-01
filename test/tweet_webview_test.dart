/*
 * Copyright (c) 2018 Larry Aasen. All rights reserved.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tweet_webview/tweet_webview.dart';

void main() {
  testWidgets('Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());

    expect(find.text('TweetWebView test'), findsOneWidget);
    expect(find.text('Loading...'), findsNWidgets(4));

    sleep(const Duration(seconds: 1));

    expect(find.text('Loading...'), findsNWidgets(4));
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tweet1 = TweetWebView(
        tweetUrl: 'https://twitter.com/Interior/status/463440424141459456');
    final tweet2 = TweetWebView(tweetID: '463440424141459456');
    final tweet3 = TweetWebView.tweetUrl(
        'https://twitter.com/Interior/status/463440424141459456');
    final tweet4 = TweetWebView.tweetID('463440424141459456');
    return MaterialApp(
      title: 'TweetWebView test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TweetWebView test'),
        ),
        body: Column(
          children: <Widget>[tweet1, tweet2, tweet3, tweet4],
        ),
      ),
    );
  }
}

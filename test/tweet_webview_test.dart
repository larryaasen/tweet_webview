import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tweet_webview/tweet_webview.dart';

void main() {
  testWidgets('Widget test', (WidgetTester tester) async {
//    await tester.pumpWidget(TweetWebView(tweetUrl: 'https://twitter.com/Interior/status/463440424141459456'));
    await tester.pumpWidget(MyWidget(message: 'message', title: 'title'));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);

    sleep(const Duration(seconds:13));

    expect(find.text('Loading...'), findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  final String title;
  final String message;

  const MyWidget({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tweet = TweetWebView(tweetUrl: 'https://twitter.com/Interior/status/463440424141459456');
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: tweet,
        ),
      ),
    );
  }
}

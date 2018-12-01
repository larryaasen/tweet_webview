/*
 * Copyright (c) 2018 Larry Aasen. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:tweet_webview/tweet_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweet WebView Example 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet WebView Example 2'),
      ),
      body: TweetWebView.tweetID('463440424141459456'),
    );
  }
}

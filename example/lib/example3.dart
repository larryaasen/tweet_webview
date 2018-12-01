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
      title: 'Tweet WebView Example 3',
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
        title: Text('Tweet WebView Example 3'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final tweets = [
      '1065424382292566017',
      '1068219397293125633',
      '1068551446029832192',
      '1065362290512293888'
    ];

    final list = ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      itemCount: tweets.length,
      itemBuilder: (context, index) {
        var tweetID = tweets[index];
        return Card(
          child: TweetWebView.tweetID(tweetID),
        );
      },
    );

    final container =
        Container(color: Colors.black26, child: Center(child: list));

    return container;
  }
}

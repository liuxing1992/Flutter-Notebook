import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _controller;
  List<Widget> gridViewItems;

  @override
  void initState() {
    super.initState();
    gridViewItems = List<Widget>();
    _controller = ScrollController();
    fetchTen();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        fetchTen();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pull to loading demo'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await new Future.delayed(const Duration(seconds: 1));
          gridViewItems.clear();
          fetchTen();
        },
        child: GridView.extent(
          maxCrossAxisExtent: 150.0,
          controller: _controller,
          children: gridViewItems,
        ),
      ),
    );
  }

  Widget _buildItem(String url){
    return Container(
      constraints: BoxConstraints.tightFor(height: 150.0),
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  fetch() async {
    final response = await http.get('http://dog.ceo/api/breeds/image/random');
    if (response.statusCode == 200) {
      setState(() {
        gridViewItems.add(_buildItem(json.decode(response.body)['message'],));
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchTen() {
    for (int i = 0; i < 10; i++) {
      fetch();
    }
  }
}

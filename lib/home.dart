import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String privateKey;

  // 正确的构造函数声明
  const HomePage({Key? key, required this.privateKey}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home Page'),
      ),
      body: Text(widget.privateKey),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooncake_plugin/mooncake_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController<VolumeButtonEvent> _controller = StreamController();
  @override
  void initState() {
    super.initState();
    MooncakePlugin.listenForVolumeButtonPress((v) {
      _controller.add(v);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Mooncake')),
          body: StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                return Center(
                  child: Text('Hello ${snapshot.data?.toMap() ?? "..."}'),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {},
            child: const Icon(Icons.edit),
          )),
    );
  }
}

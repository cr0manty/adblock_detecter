import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adblock_detecter/adblock_detecter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _detecter = AdBlockDetecter();
  bool _loading = true;

  bool? _anyAdBlockers;
  bool? _braveShields;
  bool? _operaBlocker;
  bool? _domBlocker;

  @override
  void initState() {
    super.initState();
    _initBlockers();
  }

  Future<void> _initBlockers() async {
    _anyAdBlockers = await _detecter.detectAnyAdblocker;
    _braveShields = await _detecter.detectBraveShields;
    _operaBlocker = await _detecter.detectOperaAdblocker;
    _domBlocker = _detecter.detectDomAdblocker;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (context) {
          if (_loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Any adblock: $_anyAdBlockers'),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('DOM adblock: $_domBlocker'),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Opera adblock: $_operaBlocker'),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Brave Shields: $_braveShields'),
              ),
            ],
          );
        }),
      ),
    );
  }
}

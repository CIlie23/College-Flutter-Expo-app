import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';

void main() => runApp(const FieldApp());

class FieldApp extends StatelessWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    return MaterialApp(
      title: 'Field app',
      home: Scaffold(
        appBar: AppBar(title: const Text('Field app')),
        body: Center(child: Text('Shalom de la Flutter de pe $platform')),
      ),
    );
  }
}
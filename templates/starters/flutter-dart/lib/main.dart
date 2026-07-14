import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '__PROJECT_NAME__',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HealthPage(),
      );
}

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  String _status = '';
  bool   _ok     = false;

  Future<void> _checkHealth() async {
    setState(() { _status = 'Connecting...'; _ok = false; });
    try {
      final res  = await http.get(Uri.parse('http://localhost:8000/health'));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      setState(() { _status = '✓  ${jsonEncode(data)}'; _ok = true; });
    } catch (e) {
      setState(() { _status = '✗  $e'; _ok = false; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '__PROJECT_NAME__',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _checkHealth,
                child: const Text('GET /health'),
              ),
              if (_status.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _status,
                  style: TextStyle(color: _ok ? Colors.green : Colors.red),
                ),
              ],
            ],
          ),
        ),
      );
}

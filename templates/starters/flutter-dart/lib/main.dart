import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const App());

// ── Design tokens ──────────────────────────────────────────
const _bg        = Color(0xFFF8FAFC);
const _surface   = Color(0xFFFFFFFF);
const _surface2  = Color(0xFFF1F5F9);
const _border    = Color(0xFFE2E8F0);
const _primary   = Color(0xFF4F46E5);
const _primaryH  = Color(0xFF4338CA);
const _textMain  = Color(0xFF0F172A);
const _textMuted = Color(0xFF64748B);
const _green     = Color(0xFF16A34A);
const _red       = Color(0xFFDC2626);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '__PROJECT_NAME__ — Engineering OS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            surface: _bg,
            primary: _primary,
          ),
          scaffoldBackgroundColor: _bg,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status   = '';
  String _response = '';
  bool   _ok       = false;
  bool   _loading  = false;

  Future<void> _checkHealth() async {
    setState(() { _loading = true; _status = ''; _response = ''; });
    try {
      final res  = await http.get(Uri.parse('http://localhost:8000/health'));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      setState(() {
        _ok       = true;
        _status   = 'healthy';
        _response = const JsonEncoder.withIndent('  ').convert(data);
        _loading  = false;
      });
    } catch (e) {
      setState(() {
        _ok       = false;
        _status   = 'unreachable';
        _response = e.toString();
        _loading  = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _bg,
        body: Column(
          children: [
            _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Hero(),
                        _HealthCard(
                          loading:  _loading,
                          status:   _status,
                          response: _response,
                          ok:       _ok,
                          onCheck:  _checkHealth,
                        ),
                        const SizedBox(height: 20),
                        _StackInfo(),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _Footer(),
          ],
        ),
      );
}

// ── Header ─────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xF2FFFFFF),
          border: Border(bottom: BorderSide(color: _border)),
        ),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.4), blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 8),
              const Text('Engineering OS',
                  style: TextStyle(color: _textMain, fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _surface2,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _border),
              ),
              child: const Text('__PROJECT_NAME__',
                  style: TextStyle(color: _textMuted, fontSize: 12, fontFamily: 'monospace')),
            ),
          ],
        ),
      );
}

// ── Hero ───────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 72, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PROJECT',
                style: TextStyle(
                  color: _primary, fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 2.5)),
            const SizedBox(height: 14),
            const Text('__PROJECT_NAME__',
                style: TextStyle(
                  color: _textMain, fontSize: 48, fontWeight: FontWeight.w700,
                  letterSpacing: -2, height: 1.05)),
            const SizedBox(height: 16),
            const Text('Design for evolution. Build software that survives change.',
                style: TextStyle(color: _textMuted, fontSize: 16, height: 1.65)),
          ],
        ),
      );
}

// ── Health Card ────────────────────────────────────────────
class _HealthCard extends StatelessWidget {
  const _HealthCard({
    required this.loading,
    required this.status,
    required this.response,
    required this.ok,
    required this.onCheck,
  });

  final bool         loading;
  final String       status;
  final String       response;
  final bool         ok;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: _surface2,
                border: Border(bottom: BorderSide(color: _border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Backend Status',
                      style: TextStyle(color: _textMain, fontSize: 13, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _primary.withValues(alpha: 0.2)),
                    ),
                    child: const Text('GET /health',
                        style: TextStyle(color: _primary, fontSize: 12, fontFamily: 'monospace')),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40, width: 140,
                    child: ElevatedButton(
                      onPressed: loading ? null : onCheck,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        disabledBackgroundColor: _primary.withValues(alpha: 0.5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Check Health',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  if (status.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: ok
                                ? _green.withValues(alpha: 0.3)
                                : _red.withValues(alpha: 0.3)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            color: ok
                                ? _green.withValues(alpha: 0.08)
                                : _red.withValues(alpha: 0.08),
                            child: Text(
                              ok ? '● HEALTHY' : '● UNREACHABLE',
                              style: TextStyle(
                                color: ok ? _green : _red,
                                fontSize: 12, fontWeight: FontWeight.w600,
                                fontFamily: 'monospace', letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            color: _surface2,
                            child: Text(
                              response,
                              style: const TextStyle(
                                color: _textMain, fontSize: 13,
                                fontFamily: 'monospace', height: 1.65,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}

// ── Stack Info ─────────────────────────────────────────────
class _StackInfo extends StatelessWidget {
  static const _items = [
    ('Framework',    'Engineering OS'),
    ('Frontend',     'Flutter'),
    ('Architecture', 'MVVM + Clean'),
    ('Backend',      ':8000'),
  ];

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12, runSpacing: 12,
        children: _items.map((item) => Container(
          width: 180,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _border),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.$1.toUpperCase(),
                  style: const TextStyle(
                    color: _textMuted, fontSize: 10,
                    fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              const SizedBox(height: 5),
              Text(item.$2,
                  style: const TextStyle(
                    color: _textMain, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        )).toList(),
      );
}

// ── Footer ─────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: _border))),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Built with ', style: TextStyle(color: _textMuted, fontSize: 13)),
            const Text('Engineering OS',
                style: TextStyle(color: _primary, fontSize: 13, fontWeight: FontWeight.w500)),
            const Text(' · github.com/jcarrenoa',
                style: TextStyle(color: _textMuted, fontSize: 13)),
          ],
        ),
      );
}

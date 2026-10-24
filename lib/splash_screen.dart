import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Spalshscreen extends StatefulWidget {
  const Spalshscreen({super.key});
  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  int _ticks = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _ticks = _ticks + 1;
      });
      if (_ticks >= 10) {
        timer.cancel();
      }
    });
    _scan();
    print('2. initState finished');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _scan() async {
    await FlutterBluePlus.startScan(
      withNames: ['ESP32-Scale'],
      timeout: const Duration(seconds: 5),
    );
    await Future.delayed(const Duration(seconds: 5));
    print('found ${FlutterBluePlus.lastScanResults.length} device(s)');
    if (FlutterBluePlus.lastScanResults.isEmpty) {
      print('scale not found');
      return;
    }

    final device = FlutterBluePlus.lastScanResults.first.device;
    await device.connect(license: License.nonprofit);
    print('connected!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "SmartVeg",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "IoT weighing & billing",
              style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16),
              color: const Color(0xFFF2F3FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _ticks >= 10
                        ? 'Scale found!'
                        : 'Scanning for ESP32-Scale...',
                  ),

                  SizedBox(height: 12),
                  LinearProgressIndicator(value: _ticks / 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

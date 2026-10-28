import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'weight_bar.dart';

class Spalshscreen extends StatefulWidget {
  const Spalshscreen({super.key});
  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  int _ticks = 0;
  Timer? _timer;
  double _grams = 0;
  bool _isStable = false;
  BluetoothCharacteristic? _weightChar;

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
    final services = await device.discoverServices();
    final service = services.firstWhere(
      (s) => s.uuid == Guid('12345678-1234-1234-1234-1234567890ab'),
    );
    final weightChar = service.characteristics.firstWhere(
      (c) => c.uuid == Guid('abcd1234-5678-90ab-cdef-1234567890ab'),
    );
    print('weight char: ${weightChar.uuid}');
    _weightChar = weightChar;
    await weightChar.setNotifyValue(true);
    weightChar.lastValueStream.listen((bytes) {
      final text = String.fromCharCodes(bytes);
      final parts = text.split(',');
      setState(() {
        _grams = double.parse(parts[0]);
        _isStable = parts[1] == '1';
      });
    });
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
                  const SizedBox(height: 12),
                  Text(
                    '${_grams.toStringAsFixed(1)} g',
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(_isStable ? 'Stable' : 'Settling...'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WeightBar(
                grams: _grams,
                isStable: _isStable,
                onTare: () {
                  _weightChar?.write('t'.codeUnits);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'product.dart';
import 'weight_bar.dart';

class WeighScreen extends StatefulWidget {
  const WeighScreen({super.key});

  @override
  State<WeighScreen> createState() => _WeighScreenState();
}

class _WeighScreenState extends State<WeighScreen> {
  double _grams = 0;
  bool _isStable = false;
  BluetoothCharacteristic? _weightChar;
  StreamSubscription<List<int>>? _weightSub;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  void dispose() {
    _weightSub?.cancel();
    super.dispose();
  }

  // Moved here from the splash screen: same code, its real home.
  Future<void> _scan() async {
    await FlutterBluePlus.startScan(
      withNames: ['ESP32-Scale'],
      timeout: const Duration(seconds: 5),
    );
    await Future.delayed(const Duration(seconds: 5));
    if (FlutterBluePlus.lastScanResults.isEmpty) {
      return;
    }

    final device = FlutterBluePlus.lastScanResults.first.device;
    await device.connect(license: License.nonprofit);
    final services = await device.discoverServices();
    final service = services.firstWhere(
      (s) => s.uuid == Guid('12345678-1234-1234-1234-1234567890ab'),
    );
    final weightChar = service.characteristics.firstWhere(
      (c) => c.uuid == Guid('abcd1234-5678-90ab-cdef-1234567890ab'),
    );
    await weightChar.setNotifyValue(true);
    _weightSub = weightChar.lastValueStream.listen((bytes) {
      final parts = String.fromCharCodes(bytes).split(',');
      setState(() {
        _grams = double.parse(parts[0]);
        _isStable = parts[1] == '1';
      });
    });
    setState(() {
      _weightChar = weightChar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.circle,
              size: 12,
              color: _weightChar != null
                  ? const Color(0xFF10B981)
                  : Colors.white38,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: WeightBar(
              grams: _grams,
              isStable: _isStable,
              onTare: () {
                _weightChar?.write('t'.codeUnits);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _tile(products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(Product p) {
    return Container(
      decoration: BoxDecoration(
        color: p.color.withValues(alpha: 0.08),
        border: Border.all(
          color: p.color.withValues(alpha: p.isWeighed ? 0.25 : 0.7),
          width: p.isWeighed ? 1 : 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 18, backgroundColor: p.color),
          const SizedBox(height: 8),
          Text(
            p.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            p.priceLabel,
            style: TextStyle(fontFamily: 'monospace', color: p.color),
          ),
        ],
      ),
    );
  }
}

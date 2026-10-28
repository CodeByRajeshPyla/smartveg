import 'package:flutter/material.dart';

class WeightBar extends StatelessWidget {
  const WeightBar({
    super.key,
    required this.grams,
    required this.isStable,
    required this.onTare,
  });

  final double grams;
  final bool isStable;
  final VoidCallback onTare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        border: Border.all(color: const Color(0xFF0F766E), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SCALE WEIGHT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F766E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(grams / 1000).toStringAsFixed(3)} kg',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _badge(),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onTare,
                child: const Text('Zero / Tare'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isStable ? const Color(0xFF059669) : const Color(0xFFFEF3C7),
        border: Border.all(
          color: isStable ? const Color(0xFF059669) : const Color(0xFF92400E),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isStable ? '✓ STABLE' : 'SETTLING',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isStable ? Colors.white : const Color(0xFF92400E),
        ),
      ),
    );
  }
}

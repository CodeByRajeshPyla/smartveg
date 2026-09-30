import 'package:flutter/material.dart';

void main() {
  runApp(const SmartvegApp());
}

class SmartvegApp extends StatelessWidget {
  const SmartvegApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smartveg",
      home: Scaffold(
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
                "IOT weighing & billing ",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

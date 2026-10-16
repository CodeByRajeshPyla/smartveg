import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const SmartvegApp());
}

class SmartvegApp extends StatelessWidget {
  const SmartvegApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Smartveg", home: const Spalshscreen());
  }
}

import 'package:flutter/material.dart';

import 'screens/login_page.dart';

void main() {
  runApp(const SimapisApp());
}

class SimapisApp extends StatelessWidget {
  const SimapisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMAPIS',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/form_provider.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wempro Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00FFA3)),
        useMaterial3: true,
      ),
      home: const FormScreen(),
    );
  }
}

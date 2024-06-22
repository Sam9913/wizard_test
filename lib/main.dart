import 'package:flutter/material.dart';
import 'package:wizard_test/ui/contact_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade600),
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

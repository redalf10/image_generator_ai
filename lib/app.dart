import 'package:flutter/material.dart';
import 'package:image_generator_ai/page/get_started_page.dart';

class TIApp extends StatelessWidget {
  const TIApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const GetStartedPage(),
    );
  }
}

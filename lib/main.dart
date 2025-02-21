import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ct_festival/config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      ProviderScope(
        child: const CtApp(),
      ),
    );
  } catch (e) {
    runApp(const MaterialApp(
        home: Center(
            child: CircularProgressIndicator())));
  }
}

class CtApp extends StatelessWidget {
  const CtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cape Town Festival',
      theme: ThemeData.light(),
      initialRoute: Routes.initial,
      routes: Routes.getRoutes(),
    );
  }
}
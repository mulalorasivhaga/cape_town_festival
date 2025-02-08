import 'package:flutter/material.dart';
import 'package:ct_festival/config/routes.dart';
import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const CtApp());
  } catch (e) {
    runApp(const MaterialApp(home: Center(child: CircularProgressIndicator())));
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
      home: MainNav(),
      routes: Routes.getRoutes(),  // Use getRoutes() here
    );
  }
}

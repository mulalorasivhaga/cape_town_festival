import 'package:ct_festival/features/dashboard_screen/view/admin_dashboard_view.dart';
import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/config/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(ProviderScope
      (child: const CtApp()));
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
      home: AdminDashboardView(),
      routes: Routes.getRoutes(),  // Use getRoutes() here
    );
  }
}

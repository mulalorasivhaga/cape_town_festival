import 'package:flutter/material.dart';
import '../../../shared/navigation/view/back_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BackToHomeNav(),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      // container to store form
      //form stores full name, email, password, age, gender
      body: Center(child:
      Text('Login View',
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
      );
  }
}

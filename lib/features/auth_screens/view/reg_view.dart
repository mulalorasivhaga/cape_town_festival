import 'package:flutter/material.dart';
import '../../../shared/navigation/view/back_button.dart';

class RegView extends StatelessWidget {
  const RegView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BackToHomeNav(),
      ),
      backgroundColor: Colors.white,
      body: Center(child: Text('Register View', style: TextStyle(color: Colors.black),
      ),
      ),
    );
  }
}
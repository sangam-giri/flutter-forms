import 'package:flutter/material.dart';
import 'package:forms_example/src/features/profile/presentation/profile_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          },
          child: Text('Profile Page'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();

  Future<void> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    Get.off(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

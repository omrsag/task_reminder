import 'package:flutter/material.dart';
import 'api.dart';
import 'register.dart';
import 'tasks_page.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String msg = "";

  Future<void> doLogin() async {
    setState(() { msg = ""; });
    final res = await Api.post("login.php", {
      "email": email.text.trim(),
      "password": pass.text.trim(),
    });

    if (res["status"] == true) {
      final user = UserData.fromJson(res["user"]);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TasksPage(user: user)),
      );
    } else {
      setState(() { msg = res["message"].toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: doLogin,
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              Text(msg, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text("Create new account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

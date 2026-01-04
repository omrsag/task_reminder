import 'package:flutter/material.dart';
import 'api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  String msg = "";

  Future<void> doRegister() async {
    setState(() { msg = ""; });
    final res = await Api.post("register.php", {
      "name": name.text.trim(),
      "email": email.text.trim(),
      "password": pass.text.trim(),
    });

    if (res["status"] == true) {
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      setState(() { msg = res["message"].toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
                controller: name,
                decoration: const InputDecoration(labelText: "Name"),
              ),
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
                onPressed: doRegister,
                child: const Text("Register"),
              ),
              const SizedBox(height: 10),
              Text(msg, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

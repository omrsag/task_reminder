import 'package:flutter/material.dart';
import 'api.dart';
import 'user.dart';

class AddTaskPage extends StatefulWidget {
  final UserData user;
  const AddTaskPage({super.key, required this.user});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final title = TextEditingController();
  final details = TextEditingController();
  String dueDate = "";
  String dueTime = "";
  String remindAt = "";
  String msg = "";

  Future<void> pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: now,
    );
    if (d == null) return;
    setState(() {
      dueDate = "${d.year}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
    });
  }

  Future<void> pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return;
    setState(() {
      dueTime = "${t.hour.toString().padLeft(2, "0")}:${t.minute.toString().padLeft(2, "0")}";
    });
  }

  Future<void> pickRemindAt() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: now,
    );
    if (d == null) return;

    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return;

    final dd = "${d.year}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
    final tt = "${t.hour.toString().padLeft(2, "0")}:${t.minute.toString().padLeft(2, "0")}";

    setState(() {
      remindAt = "$dd $tt";
    });
  }

  Future<void> save() async {
    setState(() { msg = ""; });

    if (title.text.trim().isEmpty || dueDate.isEmpty || dueTime.isEmpty) {
      setState(() { msg = "Fill title, date, time"; });
      return;
    }

    final res = await Api.post("saveTask.php", {
      "user_id": widget.user.id,
      "title": title.text.trim(),
      "details": details.text.trim(),
      "due_date": dueDate,
      "due_time": dueTime,
      "remind_at": remindAt,
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
        title: const Text("Add Task"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: details,
                  decoration: const InputDecoration(labelText: "Details (optional)"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: pickDate,
                  child: Text(dueDate.isEmpty ? "Pick Due Date" : dueDate),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: pickTime,
                  child: Text(dueTime.isEmpty ? "Pick Due Time" : dueTime),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: pickRemindAt,
                  child: Text(remindAt.isEmpty ? "Pick Remind DateTime (optional)" : remindAt),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: save,
                  child: const Text("Save"),
                ),
                const SizedBox(height: 10),
                Text(msg, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

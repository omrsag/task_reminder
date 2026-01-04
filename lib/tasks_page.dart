import 'package:flutter/material.dart';
import 'api.dart';
import 'add_task.dart';
import 'task.dart';
import 'user.dart';
import 'login.dart';

class TasksPage extends StatefulWidget {
  final UserData user;
  const TasksPage({super.key, required this.user});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];
  String msg = "";

  Future<void> loadTasks() async {
    setState(() { msg = ""; });
    final res = await Api.get("getTasks.php", {
      "user_id": widget.user.id.toString(),
    });

    if (res["status"] == true) {
      final list = (res["tasks"] as List).map((e) => Task.fromJson(e)).toList();
      setState(() { tasks = list; });
    } else {
      setState(() { msg = res["message"].toString(); });
    }
  }

  Future<void> toggleDone(Task t) async {
    final newVal = t.isDone == 1 ? 0 : 1;
    final res = await Api.post("updateTaskStatus.php", {
      "task_id": t.id,
      "is_done": newVal,
    });

    if (res["status"] == true) {
      await loadTasks();
    } else {
      setState(() { msg = res["message"].toString(); });
    }
  }

  Future<void> deleteTask(Task t) async {
    final res = await Api.post("deleteTask.php", {
      "task_id": t.id,
    });

    if (res["status"] == true) {
      await loadTasks();
    } else {
      setState(() { msg = res["message"].toString(); });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks - ${widget.user.name}"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskPage(user: widget.user)),
          );
          await loadTasks();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(msg, style: const TextStyle(color: Colors.red)),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final t = tasks[index];
                return ListTile(
                  title: Text(t.title),
                  subtitle: Text("${t.dueDate}  ${t.dueTime}${t.remindAt.trim().isEmpty ? "" : "\nRemind: ${t.remindAt}"}"),
                  leading: IconButton(
                    onPressed: () => toggleDone(t),
                    icon: Icon(t.isDone == 1 ? Icons.check_box : Icons.check_box_outline_blank),
                  ),
                  trailing: IconButton(
                    onPressed: () => deleteTask(t),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

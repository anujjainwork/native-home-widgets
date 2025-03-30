import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:native_home_widgets/db/todo_hive.dart';
import 'cubit/todo_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and Hive Flutter
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  final todoBox = await Hive.openBox<Todo>('todos');

  runApp(MyApp(todoBox: todoBox));
}

class MyApp extends StatelessWidget {
  final Box<Todo> todoBox;

  const MyApp({super.key, required this.todoBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(todoBox),
      child: const MaterialApp(
        title: 'Todo App',
        home: TodoHome(),
      ),
    );
  }
}

class TodoHome extends StatelessWidget {
  const TodoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => todoCubit.removeTodo(index),
                ),
                onTap: () => todoCubit.toggleTodoCompletion(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Show a dialog to add a new todo
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add Todo'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Todo title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final text = controller.text;
                      if (text.isNotEmpty) {
                        todoCubit.addTodo(Todo(title: text));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:native_home_widgets/db/todo_hive.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final Box<Todo> todoBox;

  TodoCubit(this.todoBox) : super([]) {
    loadTodos();
  }

  void loadTodos() {
    // Loads all todos from the Hive box
    final todos = todoBox.values.toList();
    emit(todos);
  }

  void addTodo(Todo todo) {
    // Adds a new todo to the box and refreshes the state
    todoBox.add(todo);
    loadTodos();
  }

  void removeTodo(int index) {
    // Deletes the todo at a given index and refreshes the state
    todoBox.deleteAt(index);
    loadTodos();
  }

  void toggleTodoCompletion(int index) {
    // Toggles the completion status of a todo
    final todo = todoBox.getAt(index);
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      todo.save();
      loadTodos();
    }
  }
}
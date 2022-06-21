import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);
  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void setActive() {
    state = List.from(state);
  }

  void removeTodo(Todo todotoRemove) => state = [
        for (final book in state)
          if (book != todotoRemove) book,
      ];
}

final todosProvider = StateNotifierProvider((ref) => TodosNotifier());

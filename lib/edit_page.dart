import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/task_priority.dart';
import 'package:flutter_todo/todo.dart';
import 'TodosProvider.dart';

class EditTaskPage extends ConsumerStatefulWidget {
  const EditTaskPage({Key? key}) : super(key: key);

  ConsumerState<EditTaskPage> createState() => _nameState();
}

class _nameState extends ConsumerState<EditTaskPage> {
  late String _task;
  late String _description;
  late TaskPriority _priority;
  late DateTime _dueDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTask(String task) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Task"),
      initialValue: task,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Task is Required';
        }
        return null;
      },
      onSaved: (value) {
        _task = value as String;
      },
    );
  }

  Widget _buildDescription(String description) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Description"),
      initialValue: description,
      onSaved: (value) {
        _description = value as String;
      },
    );
  }

  Widget _buildTaskPriority(TaskPriority priority) {
    String selectedValue = priority.toString().split('.').elementAt(1);
    _priority = priority;
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: "Tasks's Priority",
      ),
      value: selectedValue,
      items: <String>[
        ...TaskPriority.values
            .map((value) => value.toString().split('.').elementAt(1))
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        // gal eina kitaip, bet neradau
        if (newValue == "Low") {
          _priority = TaskPriority.Low;
        } else if (newValue == "Medium") {
          _priority = TaskPriority.Medium;
        } else if (newValue == "High") {
          _priority = TaskPriority.High;
        }
      },
    );
  }

  Widget _buildDueDate(DateTime date) {
    DateTime now = DateTime.now();
    return InputDatePickerFormField(
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2030),
      initialDate: date,
      fieldLabelText: "Task's Due Date",
      onDateSaved: (value) {
        _dueDate = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    Todo todo = arguments['todo'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Edit task"),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTask(todo.task),
                  _buildDescription(todo.description),
                  _buildTaskPriority(todo.priority),
                  _buildDueDate(todo.dueDate),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // todo priskyrus nauja objekta, liste jis nepasikeicia

                        todo.task = _task;
                        todo.description = _description;
                        todo.priority = _priority;
                        todo.dueDate = _dueDate;

                        ref.read(todosProvider.notifier).setActive();

                        //nezinau kuris atvejis geresnis

                        // ref.read(TodosProvider.notifier).removeTodo(todo);
                        // todo = Todo(
                        //     task: _task,
                        //     isDone: todo.isDone,
                        //     description: _description,
                        //     priority: _priority,
                        //     dueDate: _dueDate);
                        // ref.read(TodosProvider.notifier).addTodo(todo);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

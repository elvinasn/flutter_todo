import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/task_priority.dart';
import 'package:flutter_todo/todo.dart';
import 'TodosProvider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  ConsumerState<AddTaskPage> createState() => _nameState();
}

class _nameState extends ConsumerState<AddTaskPage> {
  late String _task;
  late String _description;
  late TaskPriority _priority;
  late DateTime _dueDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final selectedPriority = StateProvider((ref) => "Low");

  Widget _buildTask() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Task"),
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

  Widget _buildDescription() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Description"),
      onSaved: (value) {
        _description = value as String;
      },
    );
  }

  Widget _buildTaskPriority() {
    String selectedValue = ref.watch(selectedPriority);
    _priority = TaskPriority.Low;
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

  Widget _buildDueDate() {
    DateTime now = DateTime.now();
    return InputDatePickerFormField(
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2030),
      fieldLabelText: "Task's Due Date",
      onDateSaved: (value) {
        _dueDate = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Add task"),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTask(),
                  _buildDescription(),
                  _buildTaskPriority(),
                  _buildDueDate(),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ref.read(todosProvider.notifier).addTodo(
                              Todo(
                                  task: _task,
                                  description: _description,
                                  priority: _priority,
                                  dueDate: _dueDate),
                            );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

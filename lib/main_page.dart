import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'TodosProvider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  ConsumerState<MainPage> createState() => _nameState();
}

class _nameState extends ConsumerState<MainPage> {
  final hideTasksProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    final listOfTodos = ref.watch(todosProvider) as List;
    listOfTodos.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.task_alt),
        title: const Text("To Do"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 90),
          child: Column(
            children: listOfTodos.isEmpty
                ? [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: const Text(
                          'There is no tasks yet!',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]
                : [
                    Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                              value: ref.watch(hideTasksProvider),
                              onChanged: (bool newBool) {
                                ref.read(hideTasksProvider.state).state =
                                    newBool;
                              },
                            ),
                            const Text(
                              "HIDE DONE TASKS",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                    ...listOfTodos
                        .where((todo) =>
                            !todo.isDone || !ref.watch(hideTasksProvider))
                        .map(
                      (todo) {
                        Color bgc = todo.dueDate
                                    .add(const Duration(days: 1))
                                    .compareTo(DateTime.now()) <
                                0
                            ? const Color.fromARGB(255, 230, 108, 100)
                            : const Color.fromARGB(255, 190, 187, 187);
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/previewPage',
                                arguments: {"todo": todo});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgc,
                              border: Border(
                                left: BorderSide(
                                  color: todo.getColor(),
                                  width: 5,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: todo.isDone,
                                      activeColor: const Color.fromARGB(
                                          255, 54, 121, 56),
                                      onChanged: (value) {
                                        todo.isDone = value;
                                        ref
                                            .read(todosProvider.notifier)
                                            .setActive();
                                      },
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        todo.task,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/removePage',
                                            arguments: {"todo": todo});
                                      },
                                      icon: const Icon(Icons.delete),
                                      padding: const EdgeInsets.all(5),
                                      constraints: const BoxConstraints(),
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/editPage',
                                            arguments: {"todo": todo});
                                      },
                                      padding: const EdgeInsets.all(5),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.edit),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addTaskPage');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

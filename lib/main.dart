import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/main_page.dart';
import 'package:flutter_todo/remove_page.dart';
import 'edit_page.dart';
import 'main_page.dart';
import 'add_task_page.dart';
import 'preview_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _nameState();
}

class _nameState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      routes: {
        '/mainPage': (context) => const MainPage(),
        '/addTaskPage': (context) => const AddTaskPage(),
        '/removePage': (context) => const RemovePage(),
        '/editPage': (context) => const EditTaskPage(),
        '/previewPage': (context) => const PreviewPage(),
      },
      initialRoute: '/mainPage',
    );
  }
}

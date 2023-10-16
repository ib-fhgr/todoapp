import 'package:flutter/material.dart';
import 'todo_list.dart';

void main() {
  // hier startet unsere App
  runApp(const MyApp());
}

// Das Haupt-Widget unserer App - macht aber nicht viel:
// hier wird das MaterialApp-Widget angelegt, man könnte hier
// Farben und Designangaben ändern. Die eigentlich Liste ist
// dann in einer anderen Datei als eigenen Widget implementiert.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const TodoList(),
    );
  }
}

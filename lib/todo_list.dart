import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database.dart';

import 'todo_dialog.dart';
import 'todo_item.dart';

// unsere TodoListe ist ein StatefulWidget, weil sich die Liste
// ja ändern kann, wenn wir neue Einträge hinzufügen (oder alte
// Einträge abhaken)
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<TodoDatabase>(context);

    return Scaffold(
      // Der FutureBuilder wartet, bis die Datenbank geladen ist
      body: FutureBuilder(
        future: db.loadTodos(),
        builder: (context, snapshot) {
          // wenn die Datenbank noch nicht geladen ist, zeigen wir
          // einen Lade-Indikator an
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Lade-Indikator, ein drehender Kreis
            );
          } else {
            // wenn die Datenbank geladen ist, holen wir uns die Liste der TodoItems
            var todoItems = snapshot.data as List<TodoItem>;

            // die Liste wird mit einem ListView.builder angezeigt
            // sie bildet das Haupt-Widget unserer App
            return ListView.builder(
              itemCount: todoItems.length, // Anzahl der Elemente
              itemBuilder: (context, index) {
                // hier wird jedes Element gebaut (CheckboxListTile)

                // wir holen uns das TodoItem aus der Liste
                var todo = todoItems[index];

                // und bauen ein CheckboxListTile, das wir zurückgeben
                return CheckboxListTile(
                  title: Text(
                    todo.text,
                    // wenn das TodoItem erledigt ist, wird der Text grau
                    style: TextStyle(
                      color: todo.erledigt ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text("${todo.dauer} Minuten"),
                  // der Wert der Checkbox ist das erledigt-Attribut des TodoItems
                  value: todo.erledigt,
                  // wenn sich der Wert der Checkbox ändert, wird das TodoItem
                  // aktualisiert
                  onChanged: (value) {
                    setState(() {
                      // Status ändern
                      todo.erledigt = value!;

                      // und in der Datenbank speichern
                      db.save(todo);
                    });
                  },
                );
              },
            );
          }
        },
      ),
      // der FloatingActionButton wird unten rechts angezeigt
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // wenn der Button gedrückt wird, öffnen wir den Dialog
          // und warten, bis er geschlossen wird (await)
          await showDialog<TodoItem>(
            context: context,
            builder: (context) {
              return const TodoDialog();
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
  // ein paar Beispiel-Einträge, damit die Liste nicht leer ist
  var todoItems = [
    TodoItem(text: "Hausaufgaben machen", dauer: 60),
    TodoItem(text: "Kochen", dauer: 30),
    TodoItem(text: "Einkaufen", dauer: 45, erledigt: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // die Liste wird mit einem ListView.builder angezeigt
      // sie bildet das Haupt-Widget unserer App
      body: ListView.builder(
        itemCount: todoItems.length, // Anzahl der Elemente
        itemBuilder: (context, index) {
          // hier wird jedes Element gebaut

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
                todo.erledigt = value!;
              });
            },
          );
        },
      ),
      // der FloatingActionButton wird unten rechts angezeigt
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // wenn der Button gedrückt wird, öffnen wir den Dialog
          // und warten, bis er geschlossen wird (await)
          var neu = await showDialog<TodoItem>(
            context: context,
            builder: (context) {
              return const TodoDialog();
            },
          );

          // wenn der Nutzer den Dialog mit "Speichern" geschlossen hat,
          // wird das neue TodoItem der Liste hinzugefügt
          if (neu != null) {
            // setState sorgt dafür, dass sich die Liste neu aufbaut
            setState(() {
              // hier wird das neue TodoItem der Liste hinzugefügt
              todoItems.add(neu);
            });
          }
        },
      ),
    );
  }
}

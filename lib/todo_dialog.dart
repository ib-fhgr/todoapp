import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';
import 'todo_item.dart';

// unser TodoDialog ist ein StatefulWidget, weil wir die Eingaben
// des Nutzers speichern müssen (und diese sich ändern können)
class TodoDialog extends StatefulWidget {
  const TodoDialog({super.key});

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

// die State-Klasse für den TodoDialog
class _TodoDialogState extends State<TodoDialog> {
  // die Eingaben des Nutzers speichern wir in diesen Variablen
  String eingabe = '';
  int minuten = 10;

  @override
  Widget build(BuildContext context) {
    // Datenbank-Objekt holen
    final db = Provider.of<TodoDatabase>(context);

    // der Dialog ist ein AlertDialog, der die Eingaben des Nutzers
    // abfragt und dann ein TodoItem zurückgibt
    return AlertDialog(
      title: const Text("Todo-Item anlegen"),
      content: Column(
        // die Eingaben des Nutzers werden in einer Column angezeigt
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ein TextField für den Text des TodoItems
          // onChanged wird aufgerufen, wenn sich der Text ändert
          // und speichert den neuen Text in der Variable eingabe
          TextField(
            decoration: const InputDecoration(labelText: "Text"),
            onChanged: (value) {
              eingabe = value;
            },
          ),
          const SizedBox(height: 20),
          // ein Slider für die Dauer des TodoItems
          // onChanged wird aufgerufen, wenn sich der Slider ändert
          // und speichert den neuen Wert in der Variable minuten
          Slider(
            value: minuten.toDouble(),
            onChanged: (value) {
              setState(() {
                minuten = value.toInt();
              });
            },
            min: 0,
            max: 120,
            divisions: 120,
            label: "$minuten",
          ),
        ],
      ),
      actions: [
        // zwei Buttons: Abbrechen und Speichern

        // wenn der Nutzer auf Abbrechen klickt, wird der Dialog
        // geschlossen
        TextButton(
          onPressed: () {
            // Dialog schliessen
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),

        // wenn der Nutzer auf Speichern klickt, wird das TodoItem
        // zurückgegeben
        TextButton(
          onPressed: () {
            // Eingaben in ein TodoItem verpacken
            var neu = TodoItem(text: eingabe, dauer: minuten);

            // TodoItem in der Datenbank speichern
            db.save(neu);

            // Dialog schliessen
            Navigator.of(context).pop();
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todo_item.dart';

// Verwaltet unsere Datenbank und bietet Lese- und Schreiboperationen

// So sieht unsere Tabelle aus:

// TABELLE TODOS

//  id | text                | dauer | erledigt
//  -------------------------------------------
//   1 | Kochen              | 30    | 0
//   2 | Einkaufen           | 45    | 1
//   3 | Hausaufgaben machen | 60    | 0

// Ein Objekt dieser Klasse wird per Provider bereitgestellt und kann in allen Widgets genutzt werden
class TodoDatabase extends ChangeNotifier {
  // öffnet eine Datenbank und erzeugt eine leere Tabelle für
  // Todo-Items, falls die Tabelle noch nicht existiert
  Future<Database> getDatabase() async {
    // Pfad zur Datenbank-Datei holen (dies ist auf jedem System etwas anders, daher
    // nutzt man besser das Path-Plugin dafür)
    var path = await getDatabasesPath();

    // Datenbank öffnen
    return await openDatabase(
      join(path, "todo.db"), // Datei, in der die Daten gespeichert werden
      version: 1, // 1. Version
      onCreate: (db, version) {
        // falls die Datenbank noch nicht exisitiert, wird hier die erste Tabelle
        // mit Beispieldaten erzeugt
        db.execute(
            "CREATE TABLE todos (id INTEGER PRIMARY KEY, text TEXT, dauer INTEGER, erledigt BOOLEAN)");
        db.insert("todos", {
          "id": 1,
          "text": "Hausaufgaben machen",
          "dauer": 60,
          "erledigt": false
        });
        db.insert("todos", {
          "id": 2,
          "text": "Kochen",
          "dauer": 30,
          "erledigt": false,
        });
        db.insert("todos", {
          "id": 3,
          "text": "Einkaufen",
          "dauer": 45,
          "erledigt": true,
        });
      },
    );
  }

  // lädt alle Todo-Items aus der Datenbank
  // Vorsicht: Zeitverzögerung, daher müssen wir mit Future<...> arbeiten
  Future<List<TodoItem>> loadTodos() async {
    var db = await getDatabase(); // Datenbank öffnen
    var result = await db.query("todos"); // Tabelle todos lesen (eine Query)

    // Ergebnis in unsere TodoItem-Objekte verpacken
    // (damit kann man später besser arbeiten)
    return result.map((row) {
      return TodoItem(
        id: row["id"] as int?,
        text: row["text"].toString(),
        dauer: row["dauer"] as int,
        erledigt: row["erledigt"] == 1,
      );
    }).toList();
  }

  // speichert ein Todo-Item in der Datenbank
  // Vorsicht: Zeitverzögerung, daher müssen wir mit Future<...> arbeiten

  // hier noch eine Fallunterscheidung:
  // - wenn das TodoItem schon eine ID hat, dann aktualisieren wir es
  // - wenn das TodoItem noch keine ID hat, dann legen wir ein neues an

  Future<void> save(TodoItem todo) async {
    var db = await getDatabase();

    // wenn das TodoItem schon in der Datenbank ist, aktualisieren wir es
    // ansonsten legen wir ein neues an
    if (todo.id != null) {
      await db.update(
          "todos",
          {
            "text": todo.text,
            "dauer": todo.dauer,
            "erledigt": todo.erledigt ? 1 : 0,
          },
          where: "rowid = ?",
          whereArgs: [todo.id]);
    } else {
      await db.insert("todos", {
        "text": todo.text,
        "dauer": todo.dauer,
        "erledigt": todo.erledigt ? 1 : 0,
      });
    }

    // Beim Speichern alle Widgets informieren, damit werden die Daten geupdated
    notifyListeners();
  }
}

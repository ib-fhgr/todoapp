# todoapp

Ein kleines Beispielprojekt, welches die Verwendung einiger Flutter-Widgets zeigt.

Der Code wurde noch etwas bereinigt und mit Kommentaren versehen, ansonsten ist es der selbe Code, der im Unterricht entstanden ist.

Der Flutter-Code befindet sich wie in allen Flutter-Projekten im Ordner `lib/`, aufgeteilt in folgende Dateien:

- `main.dart`: Die Hauptdatei, die die App startet
- `todo_item.dart`: Die Klasse, die ein einzelnes Todo-Item repräsentiert
- `todo_list.dart`: Die Klasse/Widget, die die Liste der Todo-Items verwaltet
- `todo_dialog.dart`: Die Klasse/Widget, die das Dialogfenster zum Hinzufügen eines neuen Todo-Items verwaltet

Neu: 

- in der Datei `database.dart` befindet sich der Code, der die Datenbank verwaltet, dieser wird mit dem Paket `sqflite` realisiert. Der Zugriff auf das Datenbank-Objekt erfolgt mit Hilfe des Provider-Plugins (siehe veränderte `main`-Funktion).
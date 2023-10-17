// eine kleine Daten-Klasse für unsere Todo-Items
class TodoItem {
  int? id;
  String text;
  int dauer;
  bool erledigt;

  TodoItem({this.id, this.text = '', this.dauer = 10, this.erledigt = false});
}

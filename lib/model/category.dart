class Category {
  int id;
  String title;
  int color;

  Category(this.id, this.title, this.color);

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'color': color};
  }
}

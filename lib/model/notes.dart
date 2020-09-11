class Notes {
  int id;
  String title, content;
  DateTime create, lastUpdated;
  bool active;
  int category;

  Notes(this.id, this.title, this.content, this.create, this.lastUpdated,
      this.active, this.category);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'create': create,
      'lastUpdated': lastUpdated,
      'active': active,
      'category': category
    };
  }
}

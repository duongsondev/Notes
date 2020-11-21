class Notes {
  int id;
  String title, content;
  int type;
  DateTime dateCreated, lastUpdated;
  int active;

  Notes(this.id, this.title, this.content, this.type, this.dateCreated, this.lastUpdated, this.active);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'dateCreated': dateCreated.toString(),
      'lastUpdated': lastUpdated.toString(),
      'active': active,
    };
  }
}

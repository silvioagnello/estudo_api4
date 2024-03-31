class Favorite {
  String id;

  Favorite({required this.id});

  Favorite.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  @override
  String toString() {
    return 'Favorite {id: $id}';
  }
}

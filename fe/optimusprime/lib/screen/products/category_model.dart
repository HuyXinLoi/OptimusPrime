class Category {
  final String id;
  final String name;
  final String type;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "type": type,
      "description": description,
    };
  }
}

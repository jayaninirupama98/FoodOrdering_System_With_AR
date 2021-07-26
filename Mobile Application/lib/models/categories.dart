class Category {
  String id, name, imageURL;

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    imageURL = map["imageURL"];
    id = map["id"];
  }
}

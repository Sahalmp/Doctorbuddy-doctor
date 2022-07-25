class CategoryModel {
  String? name, image;

  CategoryModel({this.name, this.image});

  factory CategoryModel.fromMap(map) {
    return CategoryModel(name: map['name'], image: map['image']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class SuggestfField {
  static List<String> getSuggestions(String query, List<String> list) {
    List<String> matches = <String>[];
    matches.addAll(list);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class Recipe {
  final String title;
  final String image;
  final int cookingTime;
  final int id;

  Recipe({
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id
  });

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
        title: json['title'] as String,
        image: (json['image'] ?? 'https://fakeimg.pl/312x231?text=No+Image+Available') as String,
        cookingTime: json['readyInMinutes'] as int,
        id: json['id'] as int
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $title, time: $cookingTime, image: $image}';
  }
}
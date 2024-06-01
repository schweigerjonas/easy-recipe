class DetailedRecipe {
  final String title;
  final String image;
  final int cookingTime;
  final int id;
  final int servings;
  final bool isVegan;
  final bool isVegetarian;
  final String summary;
  final double score;

  DetailedRecipe({
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id,
    required this.servings,
    required this.isVegan,
    required this.isVegetarian,
    required this.summary,
    required this.score
  });

  factory DetailedRecipe.fromJson(dynamic json) {
    return DetailedRecipe(
        title: json['title'] as String,
        image: (json['image'] ?? 'https://fakeimg.pl/312x231?text=No+Image+Available') as String,
        cookingTime: json['readyInMinutes'] as int,
        id: json['id'] as int,
        servings: json['servings'] as int,
        isVegan: json['vegan'] as bool,
        isVegetarian: json['vegetarian'] as bool,
        summary: json['summary'] as String,
        score: json['spoonacularScore'] as double
    );
  }

  static List<DetailedRecipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return DetailedRecipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $title, time: $cookingTime, image: $image}';
  }
}
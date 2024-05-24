class Recipe {
  final String name;
  final String images;
  final double rating;
  final double totalTime;

  Recipe({
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime});

  factory Recipe.fromJson(dynamic json) {
    double rating = 0.0;
    if (json['rating']['ratingValue'] != null) {
      rating = json['rating']['ratingValue'] as double;
    }
    return Recipe(
        name: json['title'] as String,
        images: json['image_urls'][0] as String,
        rating: rating,
        totalTime: json['totalTime'] as double);
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}
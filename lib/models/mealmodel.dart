//Seveeral meal items can be added to a meal, will be added as a list
//Design based on the api data returned to show the result
class MealItem {
  final String name; //Name of the food item
  double calories; //Calories for this item
  final double? fat; //Fat content in grams
  final double? protein; //Protein content in grams
  final double? carbs; //Carbohydrates content in grams
  final String? servingSize; //Serving size description
  final String? photoUrl; //Photo of item


  MealItem({
    required this.name,
    required this.calories,
    this.fat,
    this.protein,
    this.carbs,
    this.servingSize,
    this.photoUrl,
  });
//toMap and fromMap to access meal items
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbs': carbs,
      'servingSize': servingSize,
      'photoUrl': photoUrl
    };
  }

  factory MealItem.fromMap(Map<String, dynamic> map) {
    return MealItem(
      name: map['name'],
      calories: map['calories'],
      fat: map['fat'],
      protein: map['protein'],
      carbs: map['carbs'],
      servingSize: map['servingSize'],
      photoUrl: map['photoUrl'],
    );
  }
}
//Actual meal model
//Meal will have names (Breakfast/Lunch/Dinner/Snack)
class MealModel {
  final String id; // Unique identifier for the meal
  String name; // Name of the meal
  final String date; // Date when the meal was consumed
  double calories; // Total calories of the meal
  final List<MealItem>? items; // List of meal items
  // final String? notes; // Custom notes for the meal (optional)

  MealModel({
    required this.id,
    required this.name,
    required this.date,
    required this.calories,
    this.items,
    // this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'calories': calories,
      'items': items?.map((item) => item.toMap()).toList(),
      // 'notes': notes,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      calories: map['calories'],
      items: (map['items'] as List<dynamic>?)?.map((item) => MealItem.fromMap(item as Map<String, dynamic>)).toList(),
      // notes: map['notes'],
    );
  }
}

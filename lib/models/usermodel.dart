import 'package:apptrial3/models/mealmodel.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String? photoURL;
  final String? username;
  final int? age;
  final double? weight;
  final double? height;
  final String? gender;
  final double? bmi;
  final double? bmr;
  final String? lifestyle;
  final double? caloricIntake;
  final List<MealModel> meals; //List of meals
  final double? dailyCaloricGoal; //User's daily caloric goal
  final double? totalCaloriesConsumed; //Total calories consumed today
  final double? totalProteinConsumed; //Total protein consumed today
  final double? totalCarbsConsumed; //Total carbohydrates consumed today
  final double? totalFatConsumed; //Total fat consumed today
  final Map<String, double>? mealTrackingData; //Tracking data for individual meals (meal ID as key)

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoURL,
    this.username,
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.bmi,
    this.bmr,
    this.lifestyle,
    this.caloricIntake,
    this.meals = const [], // Default to an empty list
    this.dailyCaloricGoal,
    this.totalCaloriesConsumed,
    this.totalProteinConsumed,
    this.totalCarbsConsumed,
    this.totalFatConsumed,
    this.mealTrackingData,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'username': username,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'bmi': bmi,
      'bmr': bmr,
      'lifestyle': lifestyle,
      'caloricIntake': caloricIntake,
      'meals': meals.map((meal) => meal.toMap()).toList(), // Convert list of meals to a map
      'dailyCaloricGoal': dailyCaloricGoal,
      'totalCaloriesConsumed': totalCaloriesConsumed,
      'totalProteinConsumed': totalProteinConsumed,
      'totalCarbsConsumed': totalCarbsConsumed,
      'totalFatConsumed': totalFatConsumed,
      'mealTrackingData': mealTrackingData,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      username: map['username'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
      gender: map['gender'],
      bmi: map['bmi'],
      bmr: map['bmr'],
      lifestyle: map['lifestyle'],
      caloricIntake: map['caloricIntake'],
      meals: (map['meals'] as List<dynamic>).map((mealMap) => MealModel.fromMap(mealMap)).toList(), // Convert map to list of meals
      dailyCaloricGoal: map['dailyCaloricGoal'],
      totalCaloriesConsumed: map['totalCaloriesConsumed'],
      totalProteinConsumed: map['totalProteinConsumed'],
      totalCarbsConsumed: map['totalCarbsConsumed'],
      totalFatConsumed: map['totalFatConsumed'],
      mealTrackingData: Map<String, double>.from(map['mealTrackingData'] ?? {}),
    );
  }
}

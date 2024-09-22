import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:apptrial3/providers/userprovider.dart';

class MealProvider with ChangeNotifier {
  List<MealModel> _meals = [];
  bool _isLoading = false;
  String? _error;

  List<MealModel> get meals => _meals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMealsByDate(BuildContext context, DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      _meals = await getMealsByDate(userProvider.userId, startDate, endDate);
      _error = null;
    } catch (e) {
      _error = 'Failed to load meals';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMeal(BuildContext context, MealModel newMeal) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String userId = userProvider.userId;

      // Generate a new document ID for the meal
      DocumentReference mealDoc = FirebaseFirestore.instance.collection('meals').doc();

      // Set the meal data in the new document
      await mealDoc.set({
        'userId': userId, // Reference to the user
        ...newMeal.toMap(), // Spread the meal data into the map
      });

      // Optionally, you can update the _meals list to reflect the new meal
      _meals.add(newMeal);
      notifyListeners();
    } catch (e) {
      print("Failed to add meal: $e");
    }
  }

  // Update the method signature to accept startDate and endDate as parameters
  Future<List<MealModel>> getMealsByDate(String userId, DateTime startDate, DateTime endDate) async {
    print("getMealsByDate called");
    try {
      // Format the start and end dates as strings in ISO 8601 format
      final startOfDay = DateTime(startDate.year, startDate.month, startDate.day).toIso8601String();
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59).toIso8601String();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .orderBy('date', descending: true)  // Order by date in descending order
          .get();

      final meals = querySnapshot.docs
          .map((doc) => MealModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return meals;
    } catch (e) {
      print("Failed to retrieve meals by date: $e");
      return [];
    }
  }

  Future<Map<String, double>> getDailyNutritionTotals(BuildContext context, DateTime date) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String userId = userProvider.userId;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day).toIso8601String())
          .where('date', isLessThan: DateTime(date.year, date.month, date.day + 1).toIso8601String())
          .get();

      double totalCalories = 0.0;
      double totalProtein = 0.0;
      double totalCarbs = 0.0;
      double totalFat = 0.0;

      querySnapshot.docs.forEach((doc) {
        final meal = MealModel.fromMap(doc.data() as Map<String, dynamic>);
        totalCalories += meal.calories ?? 0.0;
        meal.items?.forEach((item) {
          totalProtein += item.protein ?? 0.0;
          totalCarbs += item.carbs ?? 0.0;
          totalFat += item.fat ?? 0.0;
        });
      });

      return {
        'calories': totalCalories,
        'protein': totalProtein,
        'carbs': totalCarbs,
        'fat': totalFat,
      };
    } catch (e) {
      print("Failed to retrieve daily nutrition totals: $e");
      return {};
    }
  }
}

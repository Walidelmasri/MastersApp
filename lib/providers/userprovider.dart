import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptrial3/models/usermodel.dart';
import 'package:apptrial3/models/mealmodel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final String userId;

  UserProvider({required this.userId}) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        _user = UserModel(
          uid: doc['uid'],
          name: doc['name'],
          email: doc['email'],
          phoneNumber: doc['phoneNumber'],
          photoURL: doc['photoURL'],
          username: doc['username'],
          age: doc['age'],
          weight: doc['weight'],
          height: doc['height'],
          gender: doc['gender'],
          bmi: doc['bmi'],
          bmr: doc['bmr'],
          lifestyle: doc['lifestyle'],
          caloricIntake: doc['caloricIntake'],
          // Handle new fields
          meals: (doc['meals'] as List<dynamic>?)
              ?.map((mealMap) => MealModel.fromMap(mealMap))
              .toList() ?? [],
          dailyCaloricGoal: doc['dailyCaloricGoal'],
          totalCaloriesConsumed: doc['totalCaloriesConsumed'],
          totalProteinConsumed: doc['totalProteinConsumed'],
          totalCarbsConsumed: doc['totalCarbsConsumed'],
          totalFatConsumed: doc['totalFatConsumed'],
          mealTrackingData: Map<String, double>.from(doc['mealTrackingData'] ?? {}),
        );
      } else {
        // Create a new document with default values
        _user = UserModel(
          uid: userId,
          name: '',
          email: '',
          phoneNumber: '',
          photoURL: '',
          username: '',
          age: null,
          weight: null,
          height: null,
          gender: 'male',
          bmi: null,
          bmr: null,
          lifestyle: null,
          caloricIntake: null,
          meals: [],
          dailyCaloricGoal: null,
          totalCaloriesConsumed: null,
          totalProteinConsumed: null,
          totalCarbsConsumed: null,
          totalFatConsumed: null,
          mealTrackingData: {},
        );

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'uid': userId,
          'name': '',
          'email': '',
          'phoneNumber': '',
          'photoURL': '',
          'username': '',
          'age': null,
          'weight': null,
          'height': null,
          'gender': 'male',
          'bmi': null,
          'bmr': null,
          'lifestyle': null,
          'caloricIntake': null,
          'meals': [],
          'dailyCaloricGoal': null,
          'totalCaloriesConsumed': null,
          'totalProteinConsumed': null,
          'totalCarbsConsumed': null,
          'totalFatConsumed': null,
          'mealTrackingData': {},
        });
      }
      notifyListeners();
    } catch (e) {
      print("Failed to load user data: $e");
    }
  }

  Future<void> updateUserData({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? username,
    int? age,
    double? weight,
    double? height,
    String? gender,
    double? bmi,
    double? bmr,
    String? lifestyle, // New parameter
    double? caloricIntake,
    List<MealModel>? meals,
    double? dailyCaloricGoal,
    double? totalCaloriesConsumed,
    double? totalProteinConsumed,
    double? totalCarbsConsumed,
    double? totalFatConsumed,
    Map<String, double>? mealTrackingData,
  }) async {
    try {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot doc = await userDoc.get();
      if (!doc.exists) {
        // Create the document with default values if it doesn't exist
        await userDoc.set({
          'uid': userId,
          'name': name ?? '',
          'email': email ?? '',
          'phoneNumber': phoneNumber ?? '',
          'photoURL': photoURL ?? '',
          'username': username ?? '',
          'age': age ?? null,
          'weight': weight ?? null,
          'height': height ?? null,
          'gender': gender ?? 'male',
          'bmi': bmi ?? null,
          'bmr': bmr ?? null,
          'lifestyle': lifestyle ?? _user!.lifestyle,
          'caloricIntake': caloricIntake ?? null,
          'meals': meals?.map((meal) => meal.toMap()).toList() ?? [],
          'dailyCaloricGoal': dailyCaloricGoal,
          'totalCaloriesConsumed': totalCaloriesConsumed,
          'totalProteinConsumed': totalProteinConsumed,
          'totalCarbsConsumed': totalCarbsConsumed,
          'totalFatConsumed': totalFatConsumed,
          'mealTrackingData': mealTrackingData ?? {},
        });
      } else {
        // Update the document if it exists
        await userDoc.update({
          'name': name ?? _user!.name,
          'email': email ?? _user!.email,
          'phoneNumber': phoneNumber ?? _user!.phoneNumber,
          'photoURL': photoURL ?? _user!.photoURL,
          'username': username ?? _user!.username,
          'age': age ?? _user!.age,
          'weight': weight ?? _user!.weight,
          'height': height ?? _user!.height,
          'gender': gender ?? _user!.gender,
          'bmi': bmi ?? _user!.bmi,
          'bmr': bmr ?? _user!.bmr,
          'lifestyle': lifestyle ?? _user!.lifestyle,
          'caloricIntake': caloricIntake ?? _user!.caloricIntake,
          'dailyCaloricGoal': dailyCaloricGoal ?? _user!.dailyCaloricGoal,
          'totalCaloriesConsumed': totalCaloriesConsumed ?? _user!.totalCaloriesConsumed,
          'totalProteinConsumed': totalProteinConsumed ?? _user!.totalProteinConsumed,
          'totalCarbsConsumed': totalCarbsConsumed ?? _user!.totalCarbsConsumed,
          'totalFatConsumed': totalFatConsumed ?? _user!.totalFatConsumed,
          'mealTrackingData': mealTrackingData ?? _user!.mealTrackingData,
        });

      }

      // Manually updating the local user model to reflect changes immediately
      _user = UserModel(
        uid: userId,
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
        photoURL: photoURL ?? _user!.photoURL,
        username: username ?? _user!.username,
        age: age ?? _user!.age,
        weight: weight ?? _user!.weight,
        height: height ?? _user!.height,
        gender: gender ?? _user!.gender,
        bmi: bmi ?? _user!.bmi,
        bmr: bmr ?? _user!.bmr,
        caloricIntake: caloricIntake ?? _user!.caloricIntake,
        meals: meals ?? _user!.meals,
        dailyCaloricGoal: dailyCaloricGoal ?? _user!.dailyCaloricGoal,
        totalCaloriesConsumed: totalCaloriesConsumed ?? _user!.totalCaloriesConsumed,
        totalProteinConsumed: totalProteinConsumed ?? _user!.totalProteinConsumed,
        totalCarbsConsumed: totalCarbsConsumed ?? _user!.totalCarbsConsumed,
        totalFatConsumed: totalFatConsumed ?? _user!.totalFatConsumed,
        mealTrackingData: mealTrackingData ?? _user!.mealTrackingData,
      );

      notifyListeners();
    } catch (e) {
      print("Failed to update user data: $e");
    }

  }

}

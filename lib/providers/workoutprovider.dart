import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptrial3/models/workoutmodel.dart';
import 'package:apptrial3/services/authservice.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _workouts = [];

  List<Map<String, dynamic>> get workouts => _workouts;

  Future<void> saveWorkout({
    required String workoutName,
    int? caloriesBurned,
    required List<Workout> exercises,
  }) async {
    //Collections are saved using the userId to follow correct database design
    //principles
    final userId = AuthService.getUserId();
    final workoutsCollection = FirebaseFirestore.instance.collection('workouts_$userId');

    await workoutsCollection.add({
      'workoutName': workoutName,
      'caloriesBurned': caloriesBurned,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'createdAt': Timestamp.now(),
    });

    //Fetch workouts again after saving to update the state
    await fetchWorkouts();
    // notifyListeners();
  }

  Future<void> fetchWorkouts() async {
    final userId = AuthService.getUserId();
    final workoutsCollection = FirebaseFirestore.instance.collection('workouts_$userId');
    final snapshot = await workoutsCollection.get();

    _workouts = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  // New method to fetch workouts by date range
  Future<List<Map<String, dynamic>>> getWorkoutsByDate(
      DateTime startDate, DateTime endDate) async {
    final userId = AuthService.getUserId();
    final workoutsCollection = FirebaseFirestore.instance.collection('workouts_$userId');

    final adjustedEndDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final snapshot = await workoutsCollection
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(adjustedEndDate))
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

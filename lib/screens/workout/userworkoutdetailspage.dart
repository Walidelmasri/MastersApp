import 'package:flutter/material.dart';
import 'package:apptrial3/models/workoutmodel.dart';

class UserWorkoutDetailsPage extends StatelessWidget {
  final Map<String, dynamic> workout;

  UserWorkoutDetailsPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    // Convert the exercises list from Map<String, dynamic> to List<Workout>
    final List<Workout> exercises = (workout['exercises'] as List<dynamic>)
        .map((exercise) => Workout.fromJson(exercise as Map<String, dynamic>, 0))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(workout['workoutName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      exercise.gifUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    ),
                    SizedBox(height: 20),
                    Text('Sets: ${exercise.sets.length}'),
                    Text('Target Muscle: ${exercise.target}'),
                    SizedBox(height: 10),
                    _buildSetDetails(exercise),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSetDetails(Workout exercise) {
    return Column(
      children: List.generate(exercise.sets.length, (index) {
        final set = exercise.sets[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Set ${index + 1}'),
            Text('Reps: ${set.reps}'),
            Text('Weight: ${set.weight} kg'),
          ],
        );
      }),
    );
  }
}

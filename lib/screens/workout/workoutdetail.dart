import 'package:flutter/material.dart';
import 'package:apptrial3/models/workoutmodel.dart';

class WorkoutDetailPage extends StatelessWidget {
  final Workout workout;

  WorkoutDetailPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _capitalize(workout.name),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centering the column contents horizontally
          children: [
            // Image in a Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  workout.gifUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            SizedBox(height: 20),
            //Combined Card for Target, Secondary Muscles, and Equipment
            Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target: ${_capitalize(workout.target)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      if (workout.secondaryMuscles != null && workout.secondaryMuscles!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Secondary Muscles:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _capitalize(workout.secondaryMuscles!.join(', ')),
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      Text(
                        'Equipment: ${_capitalize(workout.equipment)}',
                        style: TextStyle(fontSize: 16), // Matching font size with secondary muscles
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Instructions in a separate Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ...workout.instructions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String instruction = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${index + 1}. ${_capitalize(instruction)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

import 'package:apptrial3/providers/workoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:apptrial3/models/workoutmodel.dart';
import 'package:provider/provider.dart';

import '../../models/setmodel.dart';

class FinalizeWorkoutPage extends StatefulWidget {
  final List<Workout> selectedExercises;

  FinalizeWorkoutPage({required this.selectedExercises});

  @override
  _FinalizeWorkoutPageState createState() => _FinalizeWorkoutPageState();
}

class _FinalizeWorkoutPageState extends State<FinalizeWorkoutPage> {
  String _workoutName = '';
  String _caloriesBurned = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalize Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _workoutName = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Calories Burned (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _caloriesBurned = value;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedExercises.length,
                itemBuilder: (context, index) {
                  final workout = widget.selectedExercises[index];
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
                            workout.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Image.network(
                            workout.gifUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                          SizedBox(height: 20),
                          _buildSetRepsWeightInput(workout),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                workout.addSet();
                              });
                            },
                            child: Text('Add Set'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add validation and saving logic here
            if (_workoutName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a workout name')),
              );
              return;
            }

            // Save the workout to Firestore
            final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
            workoutProvider.saveWorkout(
              workoutName: _workoutName,
              caloriesBurned: _caloriesBurned.isNotEmpty
                  ? int.parse(_caloriesBurned)
                  : null,
              exercises: widget.selectedExercises,
            );

            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);

          },
          child: Text('Finalize and Save'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetRepsWeightInput(Workout workout) {
    return Column(
      children: List.generate(workout.sets.length, (setIndex) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Set ${setIndex + 1}'),
              SizedBox(width: 10),
              _buildTextField(
                labelText: 'Reps',
                initialValue: workout.sets[setIndex].reps.toString(),
                onChanged: (value) {
                  workout.sets[setIndex].reps = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(width: 10),
              _buildTextField(
                labelText: 'Weight',
                initialValue: workout.sets[setIndex].weight.toString(),
                onChanged: (value) {
                  workout.sets[setIndex].weight = double.tryParse(value) ?? 0.0;
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    workout.sets.insert(setIndex + 1, SetDetail(
                      reps: workout.sets[setIndex].reps,
                      weight: workout.sets[setIndex].weight,
                    ));
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    workout.sets.removeAt(setIndex);
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: initialValue),
      ),
    );
  }
}

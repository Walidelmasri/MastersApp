// import 'package:flutter/material.dart';
// import 'package:apptrial3/models/workoutmodel.dart';
// import 'package:apptrial3/services/exercisedbservice.dart';
// import 'package:apptrial3/screens/workout/workoutdetail.dart';
//
// import 'finalizeworkoutpage.dart';
//
// class WorkoutSearchPage extends StatefulWidget {
//   @override
//   _WorkoutSearchPageState createState() => _WorkoutSearchPageState();
// }
//
// class _WorkoutSearchPageState extends State<WorkoutSearchPage> {
//   final ExerciseDBService _exerciseService = ExerciseDBService();
//   List<Workout> _exercises = [];
//   bool _isLoading = false;
//   String _query = '';
//   List<String> _selectedBodyParts = ['All'];
//   List<String> _selectedEquipments = ['All'];
//   List<String> _selectedTargets = ['All'];
//
//   List<String> _bodyParts = ['All'];
//   List<String> _equipments = ['All'];
//   List<String> _targets = ['All'];
//   List<Workout> _selectedExercises = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDropdownOptions();
//   }
//
//   Future<void> _fetchDropdownOptions() async {
//     try {
//       final bodyParts = await _exerciseService.fetchAndCapitalizeBodyParts();
//       final equipments = await _exerciseService.fetchEquipments();
//       final targets = await _exerciseService.fetchTargetMuscles();
//
//       setState(() {
//         _bodyParts.addAll(bodyParts);
//         _equipments.addAll(equipments);
//         _targets.addAll(targets);
//       });
//     } catch (e) {
//       print('Failed to load dropdown options: $e');
//     }
//   }
//
//   Future<void> _searchExercises() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       List<Workout> exercises = await _exerciseService.fetchExercisesByName(_query);
//
//       if (!_selectedBodyParts.contains('All')) {
//         exercises = exercises.where((exercise) => _selectedBodyParts.contains(exercise.bodyPart)).toList();
//       }
//       if (!_selectedEquipments.contains('All')) {
//         exercises = exercises.where((exercise) => _selectedEquipments.contains(exercise.equipment)).toList();
//       }
//       if (!_selectedTargets.contains('All')) {
//         exercises = exercises.where((exercise) => _selectedTargets.contains(exercise.target)).toList();
//       }
//
//       setState(() {
//         _exercises = exercises;
//       });
//     } catch (e) {
//       print('Failed to load exercises: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showMultiSelectDialog({
//     required String title,
//     required List<String> options,
//     required List<String> selectedValues,
//     required ValueChanged<List<String>> onSelectionChanged,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Select $title'),
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: options.map((option) {
//                     return CheckboxListTile(
//                       title: Text(option),
//                       value: selectedValues.contains(option),
//                       onChanged: (bool? selected) {
//                         setState(() {
//                           if (selected == true) {
//                             if (option == 'All') {
//                               selectedValues.clear();
//                               selectedValues.add('All');
//                             } else {
//                               selectedValues.remove('All');
//                               selectedValues.add(option);
//                             }
//                           } else {
//                             selectedValues.remove(option);
//                             if (selectedValues.isEmpty) {
//                               selectedValues.add('All');
//                             }
//                           }
//                         });
//                         onSelectionChanged(selectedValues);
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _searchExercises();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Exercises'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.list),
//             onPressed: () {
//               if (_selectedExercises.isNotEmpty) {
//                 _showSelectedExercisesDialog();
//               }
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildSearchBar(),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildFilterButton(
//                           label: 'Body Part',
//                           selectedValues: _selectedBodyParts,
//                           options: _bodyParts,
//                           onPressed: () {
//                             _showMultiSelectDialog(
//                               title: 'Body Part',
//                               options: _bodyParts,
//                               selectedValues: _selectedBodyParts,
//                               onSelectionChanged: (newValues) {
//                                 setState(() {
//                                   _selectedBodyParts = newValues;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                         _buildFilterButton(
//                           label: 'Equipment',
//                           selectedValues: _selectedEquipments,
//                           options: _equipments,
//                           onPressed: () {
//                             _showMultiSelectDialog(
//                               title: 'Equipment',
//                               options: _equipments,
//                               selectedValues: _selectedEquipments,
//                               onSelectionChanged: (newValues) {
//                                 setState(() {
//                                   _selectedEquipments = newValues;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                         _buildFilterButton(
//                           label: 'Target Muscle',
//                           selectedValues: _selectedTargets,
//                           options: _targets,
//                           onPressed: () {
//                             _showMultiSelectDialog(
//                               title: 'Target Muscle',
//                               options: _targets,
//                               selectedValues: _selectedTargets,
//                               onSelectionChanged: (newValues) {
//                                 setState(() {
//                                   _selectedTargets = newValues;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Expanded(
//               child: ListView.builder(
//                 itemCount: _exercises.length,
//                 itemBuilder: (context, index) {
//                   final workout = _exercises[index];
//                   final isSelected = _selectedExercises.contains(workout); // Check if the workout is selected
//
//                   return Card(
//                     child: ListTile(
//                       leading: Image.network(
//                         workout.gifUrl,
//                         fit: BoxFit.cover,
//                         width: 50,
//                         height: 50,
//                       ),
//                       title: Text(workout.name),
//                       subtitle: Text(
//                         '${workout.bodyPart} | ${workout.equipment} | ${workout.target}',
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(
//                           isSelected ? Icons.remove_circle : Icons.add_circle, // Change icon if selected
//                           color: isSelected ? Colors.red : Colors.green,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             if (isSelected) {
//                               _selectedExercises.remove(workout); // Remove if already selected
//                             } else {
//                               _selectedExercises.add(workout); // Add to the selected list
//                             }
//                           });
//                         },
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => WorkoutDetailPage(workout: workout),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return TextField(
//       onChanged: (value) {
//         _query = value;
//         _searchExercises(); // Instant search as the user types
//       },
//       decoration: InputDecoration(
//         labelText: 'Enter exercise name',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.search),
//       ),
//     );
//   }
//
//   Widget _buildFilterButton({
//     required String label,
//     required List<String> selectedValues,
//     required List<String> options,
//     required VoidCallback onPressed,
//   }) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           // primary: Colors.grey[200], // Background color
//           // onPrimary: Colors.black, // Text color
//         ),
//         child: Text(
//           selectedValues.contains('All')
//               ? label
//               : selectedValues.join(', '),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//   void _showSelectedExercisesDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Selected Exercises'),
//           content: Container(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _selectedExercises.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final workout = _selectedExercises[index];
//                 return ListTile(
//                   leading: Image.network(
//                     workout.gifUrl,
//                     fit: BoxFit.cover,
//                     width: 50,
//                     height: 50,
//                   ),
//                   title: Text(workout.name),
//                   subtitle: Text(
//                     '${workout.bodyPart} | ${workout.equipment} | ${workout.target}',
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.remove_circle, color: Colors.red),
//                     onPressed: () {
//                       setState(() {
//                         _selectedExercises.remove(workout);
//                       });
//                       Navigator.of(context).pop(); // Close the dialog
//                       _showSelectedExercisesDialog(); // Re-open the dialog with the updated list
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Build Your Workout'),
//               onPressed: () {
//                 if (_selectedExercises.isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FinalizeWorkoutPage(selectedExercises: _selectedExercises),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:apptrial3/models/workoutmodel.dart';
import 'package:apptrial3/services/exercisedbservice.dart';
import 'package:apptrial3/screens/workout/workoutdetail.dart';

import 'finalizeworkoutpage.dart';

class WorkoutSearchPage extends StatefulWidget {
  @override
  _WorkoutSearchPageState createState() => _WorkoutSearchPageState();
}

class _WorkoutSearchPageState extends State<WorkoutSearchPage> {
  final ExerciseDBService _exerciseService = ExerciseDBService();
  List<Workout> _exercises = [];
  bool _isLoading = false;
  String _query = '';
  List<String> _selectedBodyParts = ['All'];
  List<String> _selectedEquipments = ['All'];
  List<String> _selectedTargets = ['All'];

  List<String> _bodyParts = ['All'];
  List<String> _equipments = ['All'];
  List<String> _targets = ['All'];
  List<Workout> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownOptions();
  }

  Future<void> _fetchDropdownOptions() async {
    try {
      final bodyParts = await _exerciseService.fetchAndCapitalizeBodyParts();
      final equipments = await _exerciseService.fetchEquipments();
      final targets = await _exerciseService.fetchTargetMuscles();

      setState(() {
        _bodyParts.addAll(bodyParts);
        _equipments.addAll(equipments);
        _targets.addAll(targets);
      });
    } catch (e) {
      print('Failed to load dropdown options: $e');
    }
  }

  Future<void> _searchExercises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Workout> exercises = await _exerciseService.fetchExercisesByName(_query);

      if (!_selectedBodyParts.contains('All')) {
        exercises = exercises.where((exercise) => _selectedBodyParts.contains(exercise.bodyPart)).toList();
      }
      if (!_selectedEquipments.contains('All')) {
        exercises = exercises.where((exercise) => _selectedEquipments.contains(exercise.equipment)).toList();
      }
      if (!_selectedTargets.contains('All')) {
        exercises = exercises.where((exercise) => _selectedTargets.contains(exercise.target)).toList();
      }

      setState(() {
        _exercises = exercises;
      });
    } catch (e) {
      print('Failed to load exercises: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMultiSelectDialog({
    required String title,
    required List<String> options,
    required List<String> selectedValues,
    required ValueChanged<List<String>> onSelectionChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select $title'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: options.map((option) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: selectedValues.contains(option),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            if (option == 'All') {
                              selectedValues.clear();
                              selectedValues.add('All');
                            } else {
                              selectedValues.remove('All');
                              selectedValues.add(option);
                            }
                          } else {
                            selectedValues.remove(option);
                            if (selectedValues.isEmpty) {
                              selectedValues.add('All');
                            }
                          }
                        });
                        onSelectionChanged(selectedValues);
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _searchExercises();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Exercises'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              if (_selectedExercises.isNotEmpty) {
                _showSelectedExercisesDialog();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final workout = _exercises[index];
                  final isSelected = _selectedExercises.contains(workout); // Check if the workout is selected

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        workout.gifUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(workout.name),
                      subtitle: Text(
                        '${workout.bodyPart} | ${workout.equipment} | ${workout.target}',
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected ? Icons.remove_circle : Icons.add_circle, // Change icon if selected
                          color: isSelected ? Colors.red : Colors.green,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              _selectedExercises.remove(workout); // Remove if already selected
                            } else {
                              _selectedExercises.add(workout); // Add to the selected list
                            }
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailPage(workout: workout),
                          ),
                        );
                      },
                    ),
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          onChanged: (value) {
            _query = value;
          },
          decoration: InputDecoration(
            labelText: 'Enter exercise name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchExercises(); // Trigger search when button is pressed
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectedExercisesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Exercises'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedExercises.length,
              itemBuilder: (BuildContext context, int index) {
                final workout = _selectedExercises[index];
                return ListTile(
                  leading: Image.network(
                    workout.gifUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(workout.name),
                  subtitle: Text(
                    '${workout.bodyPart} | ${workout.equipment} | ${workout.target}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red, size: 30,),
                    onPressed: () {
                      setState(() {
                        _selectedExercises.remove(workout);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                      _showSelectedExercisesDialog(); // Re-open the dialog with the updated list
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Build Your Workout'),
              onPressed: () {
                if (_selectedExercises.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalizeWorkoutPage(selectedExercises: _selectedExercises),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

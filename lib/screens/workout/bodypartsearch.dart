// import 'package:flutter/material.dart';
// import 'package:apptrial3/services/exercisedbservice.dart';
//
// class BodypartSearchPage extends StatefulWidget {
//   final String bodyPart;  // The selected body part will be passed to this page
//
//   BodypartSearchPage({required this.bodyPart});
//
//   @override
//   _BodypartSearchPageState createState() => _BodypartSearchPageState();
// }
//
// class _BodypartSearchPageState extends State<BodypartSearchPage> {
//   final ExerciseDBService _exerciseService = ExerciseDBService();
//   List<dynamic> _exercises = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchExercises(widget.bodyPart);  // Fetch exercises for the selected body part
//   }
//
//   Future<void> _fetchExercises(String bodyPart) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final exercises = await _exerciseService.fetchExercisesByBodyPart(bodyPart);
//       setState(() {
//         _exercises = exercises;
//       });
//     } catch (e) {
//       // Handle error appropriately
//       print('Error fetching exercises: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exercises for ${widget.bodyPart.capitalize()}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : _exercises.isEmpty
//             ? Center(child: Text('No exercises found for this body part'))
//             : ListView.builder(
//           itemCount: _exercises.length,
//           itemBuilder: (context, index) {
//             final exercise = _exercises[index];
//             return Card(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               child: ListTile(
//                 leading: Image.network(exercise['gifUrl']),
//                 title: Text(exercise['name']),
//                 subtitle: Text('Target: ${exercise['target']}'),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// extension StringExtension on String {
//   String capitalize() {
//     return this[0].toUpperCase() + this.substring(1);
//   }
// }
import 'package:flutter/material.dart';
import 'package:apptrial3/services/exercisedbservice.dart';
import 'package:apptrial3/models/workoutmodel.dart'; // Import the Workout model
import 'package:apptrial3/screens/workout/workoutdetail.dart'; // Import the WorkoutDetailPage

class BodypartSearchPage extends StatefulWidget {
  final String bodyPart;  // The selected body part will be passed to this page

  BodypartSearchPage({required this.bodyPart});

  @override
  _BodypartSearchPageState createState() => _BodypartSearchPageState();
}

class _BodypartSearchPageState extends State<BodypartSearchPage> {
  final ExerciseDBService _exerciseService = ExerciseDBService();
  List<Workout> _exercises = []; // Use the Workout model
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExercises(widget.bodyPart);  // Fetch exercises for the selected body part
  }

  Future<void> _fetchExercises(String bodyPart) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final exercises = await _exerciseService.fetchExercisesByBodyPart(bodyPart);
      setState(() {
        _exercises = exercises;
      });
    } catch (e) {
      // Handle error appropriately
      print('Error fetching exercises: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises for ${widget.bodyPart.capitalize()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _exercises.isEmpty
            ? Center(child: Text('No exercises found for this body part'))
            : ListView.builder(
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.network(exercise.gifUrl),
                title: Text(exercise.name.capitalize()), // Capitalize exercise name
                subtitle: Text('Target: ${exercise.target.capitalize()}'),
                onTap: () {
                  // Navigate to WorkoutDetailPage when the exercise is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailPage(workout: exercise),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

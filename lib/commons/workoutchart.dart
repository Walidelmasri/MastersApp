// // lib/commons/workout_chart.dart
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class WorkoutChart extends StatelessWidget {
//   final List<Map<String, dynamic>> workouts;
//
//   const WorkoutChart({Key? key, required this.workouts}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Workouts Breakdown',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
//             ),
//             const SizedBox(height: 16),  // Add some space between the title and the chart
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   barGroups: _createWorkoutBarGroups(workouts),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final workoutName = workouts[value.toInt()]['workoutName'];
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text(workoutName, style: TextStyle(fontSize: 12)),
//                           );
//                         },
//                       ),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   gridData: FlGridData(show: false),
//                   barTouchData: BarTouchData(enabled: false),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   // Create bar groups for the fl_chart bar chart
//   List<BarChartGroupData> _createWorkoutBarGroups(List<Map<String, dynamic>> workouts) {
//     return List.generate(workouts.length, (index) {
//       final exercises = workouts[index]['exercises'] as List<dynamic>;
//
//       // Count the total number of sets across all exercises
//       final totalSets = exercises
//           .expand((exercise) => exercise['sets'] as List<dynamic>)
//           .length;
//
//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: totalSets.toDouble(),  // Use totalSets as the y-value
//             width: 15,
//             color: Colors.blue,
//             backDrawRodData: BackgroundBarChartRodData(
//               show: true,
//               toY: 0,  // Set the background rod to 0 since we're only counting sets
//               color: Colors.grey.withOpacity(0.2),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkoutChart extends StatelessWidget {
  final List<Map<String, dynamic>> workouts;

  const WorkoutChart({Key? key, required this.workouts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter workouts to include only those from today
    final todayWorkouts = _filterWorkoutsByToday(workouts);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Workouts Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),  // Add some space between the title and the chart
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _createWorkoutBarGroups(todayWorkouts),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final workoutName = todayWorkouts[value.toInt()]['workoutName'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(workoutName, style: TextStyle(fontSize: 12)),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to filter workouts by today's date
  List<Map<String, dynamic>> _filterWorkoutsByToday(List<Map<String, dynamic>> workouts) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return workouts.where((workout) {
      final workoutTimestamp = (workout['createdAt'] as Timestamp).toDate();
      return workoutTimestamp.isAfter(startOfDay) && workoutTimestamp.isBefore(endOfDay);
    }).toList();
  }

  // Create bar groups for the fl_chart bar chart
  List<BarChartGroupData> _createWorkoutBarGroups(List<Map<String, dynamic>> workouts) {
    return List.generate(workouts.length, (index) {
      final exercises = workouts[index]['exercises'] as List<dynamic>;

      // Count the total number of sets across all exercises
      final totalSets = exercises
          .expand((exercise) => exercise['sets'] as List<dynamic>)
          .length;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalSets.toDouble(),  // Use totalSets as the y-value
            width: 15,
            color: Colors.blue,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 0,  // Set the background rod to 0 since we're only counting sets
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ],
      );
    });
  }
}

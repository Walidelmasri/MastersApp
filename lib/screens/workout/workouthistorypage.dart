import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/workoutprovider.dart';
import 'package:apptrial3/screens/workout/userworkoutdetailspage.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final String daySuffix = _getDaySuffix(date.day);

    final DateFormat formatter = DateFormat('MMMM d\'$daySuffix\', yyyy - HH:mm');
    return formatter.format(date);
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'Last 7 Days'),
            Tab(text: 'Last 30 Days'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorkoutList(context, DateTime.now(), DateTime.now()), // Today
          _buildWorkoutList(
            context,
            DateTime.now().subtract(Duration(days: 7)),
            DateTime.now(),
          ), // Last 7 Days
          _buildWorkoutList(
            context,
            DateTime.now().subtract(Duration(days: 30)),
            DateTime.now(),
          ), // Last 30 Days
        ],
      ),
    );
  }

  Widget _buildWorkoutList(BuildContext context, DateTime startDate, DateTime endDate) {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    // If fetching workouts for today, adjust start and end times
    final startOfDay = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: workoutProvider.getWorkoutsByDate(startOfDay, endOfDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No workouts found'));
        }

        final workouts = snapshot.data!;
        return ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  workout['workoutName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Exercises: ${workout['exercises'].length}'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserWorkoutDetailsPage(workout: workout),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

}

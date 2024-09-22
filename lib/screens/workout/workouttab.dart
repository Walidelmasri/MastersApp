import 'package:flutter/material.dart';
import 'package:apptrial3/services/exercisedbservice.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/workoutprovider.dart';
import '../../commons/workoutchart.dart';
import 'bodypartsearch.dart';
import 'userworkoutdetailspage.dart';
import 'workouthistorypage.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({Key? key}) : super(key: key);

  @override
  _WorkoutTabState createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  late WorkoutProvider workoutProvider;

  @override
  void initState() {
    super.initState();
    workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    workoutProvider.fetchWorkouts(); // Fetch workouts when the page is initialized
  }

  Future<void> _refreshData() async {
    await workoutProvider.fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseDBService = ExerciseDBService();
    final List<Color> cardColors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
      Colors.cyanAccent,
    ];

    return Scaffold(
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Explore Exercises',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        FutureBuilder<List<String>>(
                          future: exerciseDBService.fetchAndCapitalizeBodyParts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              final bodyParts = snapshot.data!;
                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bodyParts.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BodypartSearchPage(
                                              bodyPart: bodyParts[index].toLowerCase(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5.0,
                                        color: cardColors[index % cardColors.length],
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          height: 100,
                                          width: 120,
                                          alignment: Alignment.center,
                                          child: Text(
                                            bodyParts[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/searchWorkout');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Search Exercise'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                WorkoutChart(workouts: provider.workouts),
                const SizedBox(height: 16),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Latest Workouts Added',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutHistoryPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Show More',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.workouts.length > 3 ? 3 : provider.workouts.length,
                          itemBuilder: (context, index) {
                            final workout = provider.workouts[index];
                            return ListTile(
                              title: Text(workout['workoutName']),
                              subtitle: Text('Exercises: ${workout['exercises'].length}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserWorkoutDetailsPage(workout: workout),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

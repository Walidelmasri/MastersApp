import 'package:apptrial3/commons/workoutchart.dart';
import 'package:apptrial3/providers/authprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/userprovider.dart';
import 'package:apptrial3/screens/workout/workouttab.dart';
import 'package:apptrial3/screens/food/foodtab.dart';
import 'package:apptrial3/commons/latestmealsadded.dart';

import '../providers/workoutprovider.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<String> _titles = ['Workout', 'Home', 'Food'];
//Three tabs that will show in the navbar
  final List<Widget> _views = [
    WorkoutTab(),
    HomeContent(),
    FoodTab(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkUserAge();
  }
//Function to check if the user's age has not been set
//and show a dialog to update user's records
  void _checkUserAge() {
    final user = context.watch<UserProvider>().user; // Use watch instead of read to rebuild when the user changes
    if (user != null && user.age == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAgeMissingDialog();
      });
    }
  }
//Dialog that prompts user to enter user details
  void _showAgeMissingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('First Time Using This App?'),
        content: Text('Click Ok to add some information about yourself so we can help you '
            'track your fitness goals'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/updateprofile');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
//Handling the navbar logic
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), //Update the AppBar title dynamically
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthenticationProvider>().signOut();
              Navigator.pushReplacementNamed(context, '/signIn');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedIndex == 1 ? Colors.deepPurple : Colors.black12,
                boxShadow: _selectedIndex == 1
                    ? [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.home,
                  size: _selectedIndex == 1 ? 42 : 30,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
//Actual content inside the Homepage, at the home tab
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Future<void> _refreshData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    await userProvider.loadUserData(); // Call your method to refresh user data
    await workoutProvider.fetchWorkouts();
  }
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          if (user == null)
            Center(child: Text('No data available'))
          else ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${user.username ?? 'User'}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Let's get on track",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Latest Details:',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Age: ${user.age?.toStringAsFixed(0) ?? 'N/A'} years',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Text(
                        'Weight: ${user.weight?.toStringAsFixed(0) ?? 'N/A'} Kg',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Text(
                        'Height: ${user.height?.toStringAsFixed(2) ?? 'N/A'} M',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
      
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Calories left for today:',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Text(
                        '${user.bmr?.toStringAsFixed(0) ?? 'N/A'}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            //Show users latest workouts
            WorkoutChart(workouts: workoutProvider.workouts),
            //Show user's latest meals added
            LatestMealsAdded(),
          ],
        ],
      ),
    );
  }
}


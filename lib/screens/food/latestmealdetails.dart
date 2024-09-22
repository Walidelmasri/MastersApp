import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/mealprovider.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:apptrial3/screens/food/mealdetails.dart';
import 'package:apptrial3/providers/userprovider.dart';
import 'package:intl/intl.dart';

class LatestMealsDetailsPage extends StatefulWidget {
  const LatestMealsDetailsPage({Key? key}) : super(key: key);

  @override
  _LatestMealsDetailsPageState createState() => _LatestMealsDetailsPageState();
}

class _LatestMealsDetailsPageState extends State<LatestMealsDetailsPage>
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
  // Method to format the date
  String _formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final String daySuffix = _getDaySuffix(date.day);

    // Format the date
    final DateFormat formatter = DateFormat('MMMM d\'$daySuffix\', yyyy - HH:mm');
    return formatter.format(date);
  }

// Method to get the day suffix
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
        title: const Text('Latest Meals Added'),
        //Three tabs for the different categories
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Last 7 Days'),
            Tab(text: 'Last 30 Days'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealsList(context, DateTime.now(), DateTime.now()), // Today
          _buildMealsList(
            context,
            DateTime.now().subtract(const Duration(days: 7)),
            DateTime.now(),
          ), //Last 7 Days
          _buildMealsList(
            context,
            DateTime.now().subtract(const Duration(days: 30)),
            DateTime.now(),
          ), //Last 30 Days
        ],
      ),
    );
  }
//Used for code redundancy. Fetches meals
  Widget _buildMealsList(BuildContext context, DateTime startDate, DateTime endDate) {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    //Adjust the endDate to include the entire end day
    final DateTime adjustedEndDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    //Use a FutureBuilder to handle the asynchronous fetching of meals
    return FutureBuilder<List<MealModel>>(
      future: mealProvider.getMealsByDate(
        Provider.of<UserProvider>(context, listen: false).userId,
        startDate,
        adjustedEndDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No meals found'));
        }

        final meals = snapshot.data!; //Make sure the data is not null
//Future builder that fetches data returns another listview builder
        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the date in a neat, smaller font on top
                    Text(
                      _formatDate(meal.date), // Format the date using the method below
                      style: const TextStyle(
                        fontSize: 14, // Smaller font size for the date
                        color: Colors.grey, // Grey color to differentiate the date
                      ),
                    ),
                    const SizedBox(height: 4), // Small space between the date and meal name
                    // Display the meal name in bold
                    Text(
                      meal.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Slightly larger font size for the meal name
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${meal.calories?.toStringAsFixed(1) ?? '0.0'} Kcal',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailsPage(meal: meal),
                    ),
                  );
                },
              )

            );
          },
        );
      },
    );
  }
}

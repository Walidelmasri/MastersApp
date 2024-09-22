import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/mealprovider.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:apptrial3/screens/food/mealdetails.dart';
import 'package:apptrial3/screens/food/latestmealdetails.dart';

class LatestMealsAdded extends StatelessWidget {
  const LatestMealsAdded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.meals;

    if (meals == null) {
      return Center(child: Text('No meals added yet'));
    }

    return Card(
      elevation: 5.0, //Adds shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), //Rounds the corners of the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), //Adds padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meals Added Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the new page with the tabs
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LatestMealsDetailsPage()),
                    );
                  },
                  child: Text('Show More'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Removes padding for a more subtle look
                    minimumSize: Size(0, 0), // Removes minimum size
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks the button size
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Table(
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Meal', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kcal', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...meals.map((meal) => _buildMealRow(context, meal)).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
//Every meal will have to be built, so used buildMealRow function to reuse code
  TableRow _buildMealRow(BuildContext context, MealModel meal) {
    final date = DateTime.parse(meal.date); // Convert string to DateTime
    return TableRow(
      children: [
        _buildMealCell(context, meal, Text('${date.day}/${date.month}/${date.year}')),
        _buildMealCell(context, meal, Text(meal.name)),
        _buildMealCell(context, meal, Text('${meal.calories?.toStringAsFixed(1) ?? '0.0'} Kcal')),
      ],
    );
  }
//Each row will have cells, again reusing code to avoid code redundancy
  Widget _buildMealCell(BuildContext context, MealModel meal, Widget child) {
    return GestureDetector(
      onTap: () {
        //Navigate to the meal details page with the meal as a parameter
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsPage(meal: meal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: child,
      ),
    );
  }
}

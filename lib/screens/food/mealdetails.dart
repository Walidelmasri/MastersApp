import 'package:flutter/material.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:intl/intl.dart';

class MealDetailsPage extends StatelessWidget {
  final MealModel meal;

  MealDetailsPage({required this.meal});

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
        title: Text(meal.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal details
            Text(
              'Meal: ${meal.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${_formatDate(meal.date)}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              'Total Calories: ${meal.calories?.toStringAsFixed(2) ?? '0.0'} kcal',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // List of meal items that is dynamic and changes in length for each meal
            Expanded(
              child: ListView.builder(
                itemCount: meal.items?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = meal.items![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.photoUrl ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                          SizedBox(width: 16), // Space between image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis, // Handles overflow
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${item.servingSize} - ${item.calories.toStringAsFixed(2)} kcal',
                                  style: TextStyle(color: Colors.grey[600]),
                                  overflow: TextOverflow.ellipsis, // Handles overflow
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'P: ${item.protein?.toStringAsFixed(2) ?? '0.0'}g',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              Text(
                                'C: ${item.carbs?.toStringAsFixed(2) ?? '0.0'}g',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              Text(
                                'F: ${item.fat?.toStringAsFixed(2) ?? '0.0'}g',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
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
    );
  }
}

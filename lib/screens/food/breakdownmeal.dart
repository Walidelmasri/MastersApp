import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/services/nutritionxservice.dart'; // Adjust the import path
import 'package:apptrial3/providers/mealprovider.dart'; // Import MealProvider
import 'package:apptrial3/models/mealmodel.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // Make sure to add this import for date formatting

class BreakdownMealPage extends StatefulWidget {
  @override
  _BreakdownMealPageState createState() => _BreakdownMealPageState();
}

class _BreakdownMealPageState extends State<BreakdownMealPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _mealDetails = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedMealType = 'Breakfast'; // Default selection
  double _totalCalories = 0.0;

  Future<void> _searchMeal(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _totalCalories = 0.0;
    });

    try {
      final apiService = Provider.of<SyndigoApiService>(context, listen: false);
      final details = await apiService.getMealDetails(query);

      setState(() {
        _mealDetails = details;
        _calculateTotalCalories();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateTotalCalories() {
    double total = 0.0;
    for (var item in _mealDetails) {
      if (item['nf_calories'] != null) {
        total += item['nf_calories'];
      }
    }
    setState(() {
      _totalCalories = total;
    });
  }

  String _capitalize(String text) {
    if (text == null || text.isEmpty) return '';
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakdown Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search for a meal',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _searchMeal(_controller.text);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchMeal(value);
                }
              },
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.grey,
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _mealDetails.length,
                itemBuilder: (context, index) {
                  final item = _mealDetails[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        item['photo']?['thumb'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 50),
                      ),
                      title: Text(
                        _capitalize(item['food_name'] ??
                            'Unknown Food'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Calories: ${item['nf_calories']?.toStringAsFixed(1) ?? 'N/A'} kcal'),
                          Text(
                              'Total Fat: ${item['nf_total_fat']?.toStringAsFixed(1) ?? 'N/A'} g'),
                          Text(
                              'Protein: ${item['nf_protein']?.toStringAsFixed(1) ?? 'N/A'} g'),
                          Text(
                              'Carbohydrates: ${item['nf_total_carbohydrate']?.toStringAsFixed(1) ?? 'N/A'} g'),
                          Text(
                              'Serving Size: ${item['serving_qty'] ?? 'N/A'} ${item['serving_unit'] ?? ''}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
            if (_mealDetails.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'Total Calories: ${_totalCalories.toStringAsFixed(1)} kcal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedMealType,
                decoration: InputDecoration(
                  labelText: 'Select Meal Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: [
                  'Breakfast',
                  'Lunch',
                  'Dinner',
                  'Snack',
                ].map((mealType) {
                  return DropdownMenuItem(
                    value: mealType,
                    child: Text(mealType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMealType = value ?? 'Breakfast';
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Meal'),
                onPressed: () {
                  //This page will give all of the items and only uploading them to the database
                  //is necessary. Some records in the database are not complete, therefore
                  //function tries to upload what is given or a default value so as not
                  //to break the code
                  final mealProvider = Provider.of<MealProvider>(context, listen: false);
                  final uuid = Uuid();
                  final newMeal = MealModel(
                    id: uuid.v4(),
                    name: _selectedMealType,
                    date: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),  // Convert DateTime to String
                    calories: _totalCalories,
                    items: _mealDetails.map((item) => MealItem(
                      name: item['food_name'] ?? 'Unknown',
                      calories: (item['nf_calories'] ?? 0).toDouble(),
                      fat: (item['nf_total_fat'] ?? 0).toDouble(),
                      protein: (item['nf_protein'] ?? 0.0).toDouble(),
                      carbs: (item['nf_total_carbohydrate'] ?? 0).toDouble(),
                      servingSize: '${item['serving_qty']} ${item['serving_unit']}',
                      photoUrl: item['photo']['thumb'],
                    )).toList(),
                  );
                  //Upload meal and notify all listeners to update UI
                  mealProvider.addMeal(context, newMeal);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Meal added as $_selectedMealType',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

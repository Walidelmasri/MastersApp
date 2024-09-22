import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/services/nutritionxservice.dart';
import 'package:apptrial3/screens/food/productdetails.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:apptrial3/providers/mealprovider.dart';
import 'package:uuid/uuid.dart';
class AddMealPage extends StatefulWidget {
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  //Create a meal model to add the meal items to
  MealModel currentMeal = MealModel(
    id: 'meal_id',
    name: 'New Meal',
    date: DateTime.now().toIso8601String(),
    calories: 0.0,
    items: [],
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }
//Make the search bar trigger by adding more text in the textfield, without
//having to click search
  void _onSearchTextChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _search();
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }
//Function to search meals using the APIService (NutriotionX)
  Future<void> _search() async {
    final apiService = Provider.of<SyndigoApiService>(context, listen: false);
    final results = await apiService.searchMeals(_searchController.text);
    setState(() {
      _searchResults = results;
    });
  }

  Future<void> _addToMeal(dynamic item) async {
    final apiService = Provider.of<SyndigoApiService>(context, listen: false);

    try {
      //Fetch the full nutritional details based on the food name
      final fullDetails = await apiService.getMealDetails(item['food_name']);
      final foodDetails = fullDetails[0]; //Access the first item in the foods list retreived
      MealItem mealItem = MealItem(
        name: foodDetails['food_name'],
        calories: (foodDetails['nf_calories'] as num?)?.toDouble() ?? 0.0,
        fat: (foodDetails['nf_total_fat'] as num?)?.toDouble() ?? 0.0,
        protein: (foodDetails['nf_protein'] as num?)?.toDouble() ?? 0.0,
        carbs: (foodDetails['nf_total_carbohydrate'] as num?)?.toDouble() ?? 0.0,
        servingSize: '${foodDetails['serving_qty']} ${foodDetails['serving_unit']}',
        photoUrl: foodDetails['photo']['thumb'],
      );

      //Add to the current meal
      setState(() {
        currentMeal.items?.add(mealItem); //Adding item, making sure it is not null
        currentMeal.calories += mealItem.calories; //Update calories
      });
    } catch (e) {
      print('Failed to fetch nutritional details: $e');
    }
  }
//Prompt user to select the name of the meal from four different choices
  Future<String?> _showMealNameDialog() async {
    String? selectedMealName;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Meal Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Breakfast'),
                onTap: () => Navigator.pop(context, 'Breakfast'),
              ),
              ListTile(
                title: Text('Lunch'),
                onTap: () => Navigator.pop(context, 'Lunch'),
              ),
              ListTile(
                title: Text('Dinner'),
                onTap: () => Navigator.pop(context, 'Dinner'),
              ),
              ListTile(
                title: Text('Snack'),
                onTap: () => Navigator.pop(context, 'Snack'),
              ),
            ],
          ),
        );
      },
    );
  }
//Save meal and upload using the MealProvider
  void _saveMeal() async {
    final mealName = await _showMealNameDialog();
    if (mealName == null) return;
    setState(() {
      currentMeal.name = mealName; //Update meal name
    });
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    await mealProvider.addMeal(context, currentMeal);
    print('Meal saved successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Meal added as $mealName',
        ),
      ),
    );
    Navigator.pop(context);
    //Clean up the state after uploading the meal
    setState(() {
      currentMeal = MealModel(
        id: currentMeal.id,
        name: mealName,
        date: DateTime.now().toIso8601String(),
        calories: 0.0,
        items: [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveMeal,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for food',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            //Builder is dynamic and the length changes as the search results differ
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return ListTile(
                  leading: Image.network(
                    item['photo']['thumb'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(item['food_name']),
                  subtitle: Text(item['serving_unit']),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addToMeal(item),
                  ),
                  onTap: () {
                    //Show more details of the item passing the name as the argument
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(foodName: item['food_name']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Meal (${currentMeal.items?.length} items):',
                  style: TextStyle(fontSize: 18),
                ),
                //Display meal items from map as individual Cards
                ...?currentMeal.items?.map((item) => Card(
                  elevation: 5, // Add shadow
                  margin: EdgeInsets.symmetric(vertical: 8.0), // Spacing between cards
                  child: ListTile(
                    leading: Image.network(
                      item.photoUrl ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 50),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.servingSize} - ${item.calories.toStringAsFixed(2)} kcal'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          currentMeal.items?.remove(item);
                          currentMeal.calories -= item.calories;
                        });
                      },
                    ),
                  ),
                )),
                if (currentMeal.items!.isNotEmpty)
                  Text(
                    'Total Calories: ${currentMeal.calories.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

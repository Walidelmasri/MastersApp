import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/mealprovider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apptrial3/models/mealmodel.dart';
import 'package:apptrial3/commons/latestmealsadded.dart';

class FoodTab extends StatefulWidget {
  const FoodTab({Key? key}) : super(key: key);

  @override
  _FoodTabState createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  late Future<void> _fetchMealsFuture;

  @override
  void initState() {
    super.initState();
    _fetchMealsFuture = _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    await mealProvider.fetchMealsByDate(context, DateTime.now(), DateTime.now());
  }
//Function to refresh the page when dragging it down
  Future<void> _refreshMeals() async {
    setState(() {
      _fetchMealsFuture = _fetchMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshMeals,
        child: FutureBuilder<void>(
          future: _fetchMealsFuture,
          builder: (context, snapshot) {
            if (mealProvider.isLoading) {
              //While the meals are fetched
              return const Center(child: CircularProgressIndicator());
            } else if (mealProvider.error != null) {
              return Center(child: Text(mealProvider.error!));
            } else {
              final meals = mealProvider.meals;

              if (meals == null) {
                return const Center(child: Text('No data available'));
              }
//If meals are fetched without any errors then build the following page wrapped in
//a list view so as to never encounter any rendering errors
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Card around the top element
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
                            _buildHeader('Today\'s Meals Breakdown'),
                            _buildNutrientBreakdown(meals),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _buildActionButtons(context),
                    const SizedBox(height: 16),
                    // Card around the bar chart
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
                            _buildHeader('Meals History Broken Down'),
                            _buildGraph(meals),
                            const SizedBox(height: 8),
                            _buildLegend(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    //LatestMealsAdded widget
                    const LatestMealsAdded(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/breakdownMeal');
            },
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('What did you eat?'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addMeal');
            },
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Search by Meal/Item'),
          ),
        ],
      ),
    );
  }
//Widget to build the three circles showing the day's breakdown
  Widget _buildNutrientBreakdown(List<MealModel> meals) {
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var meal in meals) {
      if (meal.items != null) {
        for (var item in meal.items!) {
          totalProteins += item.protein ?? 0.0;
          totalCarbs += item.carbs ?? 0.0;
          totalFats += item.fat ?? 0.0;
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutrientIndicator('Proteins', totalProteins / 100, Colors.green),
        _buildNutrientIndicator('Carbohydrates', totalCarbs / 100, Colors.red),
        _buildNutrientIndicator('Fats', totalFats / 100, Colors.blue),
      ],
    );
  }
//Used for avoiding code redundancy inside the nutrient breakdown function
  Widget _buildNutrientIndicator(String label, double value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value.clamp(0.0, 1.0),
                color: color,
                backgroundColor: Colors.grey[200],
              ),
              Center(child: Text('${(value * 100).toStringAsFixed(0)}%')),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildGraph(List<MealModel> meals) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < meals.length; i++) {
      final meal = meals[i];
      double protein = 0.0, carbs = 0.0, fats = 0.0;

      if (meal.items != null) {
        for (var item in meal.items!) {
          protein += item.protein ?? 0.0;
          carbs += item.carbs ?? 0.0;
          fats += item.fat ?? 0.0;
        }
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: protein, color: Colors.green, width: 10),
            BarChartRodData(toY: carbs, color: Colors.red, width: 10),
            BarChartRodData(toY: fats, color: Colors.blue, width: 10),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          gridData: FlGridData(show: false), //Hide gridlines
          borderData: FlBorderData(
            show: false, //Hide border lines
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  final mealIndex = value.toInt();
                  if (mealIndex < 0 || mealIndex >= meals.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0, // Increase space between labels and chart
                    child: Text(
                      meals[mealIndex].name,
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(4),
              tooltipRoundedRadius: 4,
            ),
          ),
        ),
      ),
    );
  }
//Building a legend to add under the chart
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'Proteins'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.red, 'Carbs'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.blue, 'Fats'),
      ],
    );
  }
//Avoiding code redundancy
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

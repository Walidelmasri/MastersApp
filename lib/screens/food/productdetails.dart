import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/services/nutritionxservice.dart';

class ProductDetailsPage extends StatefulWidget {
  final String foodName;
//Required arguments to show details about the food item, searching will be
//by name
  ProductDetailsPage({required this.foodName});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;
  Map<String, dynamic>? product;

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<SyndigoApiService>(context);
//Load the details using a future builder to assure retrieval of data
    return FutureBuilder<List<dynamic>>(
      future: apiService.getMealDetails(widget.foodName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Product Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Product Details')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Product Details')),
            body: Center(child: Text('No details found')),
          );
        }

        if (product == null) {
          product = snapshot.data![0];
        }

        final int calories = (product!['nf_calories'] as double).toInt();

        return Scaffold(
          appBar: AppBar(title: Text(product!['food_name'] ?? 'Product Details')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        product!['photo']['thumb'],
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  product!['food_name'] ?? 'No Name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  product!['serving_unit'] ?? 'No Serving Unit',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Nutrient', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    _buildNutritionTableRow('Calories', '${product!['nf_calories']} kcal'),
                    _buildNutritionTableRow('Total Fat', '${product!['nf_total_fat']} g'),
                    _buildNutritionTableRow('Saturated Fat', '${product!['nf_saturated_fat']} g'),
                    _buildNutritionTableRow('Cholesterol', '${product!['nf_cholesterol']} mg'),
                    _buildNutritionTableRow('Sodium', '${product!['nf_sodium']} mg'),
                    _buildNutritionTableRow('Carbohydrates', '${product!['nf_total_carbohydrate']} g'),
                    _buildNutritionTableRow('Dietary Fiber', '${product!['nf_dietary_fiber']} g'),
                    _buildNutritionTableRow('Sugars', '${product!['nf_sugars']} g'),
                    _buildNutritionTableRow('Protein', '${product!['nf_protein']} g'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity', style: TextStyle(fontSize: 18)),
                    DropdownButton<int>(
                      value: _quantity,
                      onChanged: (int? newValue) {
                        setState(() {
                          _quantity = newValue!;
                        });
                      },
                      items: List.generate(10, (index) => index + 1)
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    Text(
                      'Total: ${calories * _quantity} kcal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
//Avoiding code redundancy
  TableRow _buildNutritionTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/userprovider.dart';

class ViewPersonalDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard('Name', user?.name ?? ''),
            _buildDetailCard('Username', user?.username ?? ''),
            _buildDetailCard('Age', user?.age?.toString() ?? ''),
            _buildDetailCard('Weight (kg)', user?.weight?.toString() ?? ''),
            _buildDetailCard('Height (m)', user?.height?.toString() ?? ''),
            _buildDetailCard('Gender', user?.gender ?? ''),
            _buildDetailCard('BMI', user?.bmi?.toStringAsFixed(2) ?? ''),
            _buildDetailCard('BMR', user?.bmr?.toStringAsFixed(2) ?? ''),
            _buildDetailCard('Caloric Intake', user?.caloricIntake?.toStringAsFixed(2) ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

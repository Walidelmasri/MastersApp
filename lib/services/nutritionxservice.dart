import 'dart:convert';
import 'package:http/http.dart' as http;

class SyndigoApiService {
  //Base URL that endpoints are added to
  //and API key that will be used along with headers requested by API
  final String _apiKey = '3c7ea2cb4db1ae3dee00dc10ff0f96d3';
  final String _baseUrl = 'https://trackapi.nutritionix.com/v2'; // Corrected base URL

  //Search for meals using natural language query
  Future<List<dynamic>> searchMeals(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/search/instant'),
        headers: {
          'x-app-id': 'fb854125',
          'x-app-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'query': query}),
      );

      // print('Response Status: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['common'];
      } else {
        throw Exception('Failed to load meals: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in searchMeals: $e');
      throw Exception('An error occurred while searching for meals: $e');
    }
  }

//Get detailed information about a specific meal item using its ID or
//search for meals using natural language query
  Future<List<dynamic>> getMealDetails(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/natural/nutrients'),
        headers: {
          'x-app-id': 'fb854125',
          'x-app-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'query': query}),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['foods'] as List<dynamic>;
      } else {
        throw Exception('Failed to load meal details: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in getMealDetails: $e');
      throw Exception('An error occurred while retrieving meal details: $e');
    }
  }
}

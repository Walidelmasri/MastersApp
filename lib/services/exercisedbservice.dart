// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // class ExerciseDBService {
// //   static const String _baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';
// //   static const Map<String, String> _headers = {
// //     'Content-Type': 'application/json',
// //     'Accept': 'application/json',
// //     'x-rapidapi-key': 'b11a2787d9mshc24693d9ce2dba9p1d5223jsn21e7645db487', // Replace with your actual API key
// //     'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
// //   };
// //
// //   // Fetch exercises by body part
// //   Future<List<dynamic>> fetchExercisesByBodyPart(String bodyPart, {int limit = 15, int offset = 0}) async {
// //     final response = await http.get(
// //       Uri.parse('$_baseUrl/bodyPart/$bodyPart?limit=$limit&offset=$offset'),
// //       headers: _headers,
// //     );
// //
// //     if (response.statusCode == 200) {
// //       // Successfully fetched exercises, parse and return the list
// //       return json.decode(response.body);
// //     } else {
// //       // Log detailed error information
// //       print('Failed to load exercises');
// //       print('Status Code: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //       // You can throw an exception with more details
// //       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
// //     }
// //   }
// //   Future<List<String>> fetchAndCapitalizeBodyParts() async {
// //     final response = await http.get(
// //       Uri.parse('https://exercisedb.p.rapidapi.com/exercises/bodyPartList'),
// //       headers: {
// //         'x-rapidapi-key': 'b11a2787d9mshc24693d9ce2dba9p1d5223jsn21e7645db487',
// //         'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       List<String> bodyParts = List<String>.from(json.decode(response.body));
// //       return bodyParts.map((part) => part[0].toUpperCase() + part.substring(1)).toList();
// //     } else {
// //       throw Exception('Failed to load body parts');
// //     }
// //   }
// //
// //
// // // Other methods to fetch exercises can be added here, such as by equipment, target, etc.
// // }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:apptrial3/models/workoutmodel.dart';
//
// class ExerciseDBService {
//   static const String _baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';
//   static const Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'x-rapidapi-key': 'b11a2787d9mshc24693d9ce2dba9p1d5223jsn21e7645db487', // Replace with your actual API key
//     'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
//   };
//
//   // Fetch exercises by body part
//   Future<List<Workout>> fetchExercisesByBodyPart(String bodyPart, {int limit = 15, int offset = 0}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/bodyPart/$bodyPart?limit=$limit&offset=$offset'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       // Successfully fetched exercises, parse and return the list of Workout objects
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map<Workout>((json) => Workout.fromJson(json)).toList();
//     } else {
//       // Log detailed error information
//       print('Failed to load exercises');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       // You can throw an exception with more details
//       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
//
//   Future<List<String>> fetchAndCapitalizeBodyParts() async {
//     final response = await http.get(
//       Uri.parse('https://exercisedb.p.rapidapi.com/exercises/bodyPartList'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<String> bodyParts = List<String>.from(json.decode(response.body));
//       return bodyParts.map((part) => part[0].toUpperCase() + part.substring(1)).toList();
//     } else {
//       throw Exception('Failed to load body parts');
//     }
//   }
//
// // Additional methods for fetching exercises by equipment, target, etc., can be added here
// }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:apptrial3/models/workoutmodel.dart';
//
// class ExerciseDBService {
//   static const String _baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';
//   static const Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'x-rapidapi-key': 'b11a2787d9mshc24693d9ce2dba9p1d5223jsn21e7645db487', // Replace with your actual API key
//     'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
//   };
//
//   // Fetch exercises by body part
//   Future<List<Workout>> fetchExercisesByBodyPart(String bodyPart, {int limit = 15, int offset = 0}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/bodyPart/$bodyPart?limit=$limit&offset=$offset'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map<Workout>((json) => Workout.fromJson(json)).toList();
//     } else {
//       print('Failed to load exercises');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
//
//   // Fetch and capitalize body parts
//   Future<List<String>> fetchAndCapitalizeBodyParts() async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/bodyPartList'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<String> bodyParts = List<String>.from(json.decode(response.body));
//       return bodyParts.map((part) => part[0].toUpperCase() + part.substring(1)).toList();
//     } else {
//       throw Exception('Failed to load body parts');
//     }
//   }
//
//   // Fetch exercises by equipment
//   Future<List<Workout>> fetchExercisesByEquipment(String equipment, {int limit = 15, int offset = 0}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/equipment/$equipment?limit=$limit&offset=$offset'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map<Workout>((json) => Workout.fromJson(json)).toList();
//     } else {
//       print('Failed to load exercises');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
//
//   // Fetch exercises by target muscle
//   Future<List<Workout>> fetchExercisesByTarget(String target, {int limit = 15, int offset = 0}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/target/$target?limit=$limit&offset=$offset'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map<Workout>((json) => Workout.fromJson(json)).toList();
//     } else {
//       print('Failed to load exercises');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
//
//   // Fetch exercises by name
//   Future<List<Workout>> fetchExercisesByName(String name, {int limit = 15, int offset = 0}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/name/$name?limit=$limit&offset=$offset'),
//       headers: _headers,
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map<Workout>((json) => Workout.fromJson(json)).toList();
//     } else {
//       print('Failed to load exercises');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptrial3/models/workoutmodel.dart';

class ExerciseDBService {
  //Basic url that all endpoints work based on
  //Headers that are required by the API
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-rapidapi-key': 'b11a2787d9mshc24693d9ce2dba9p1d5223jsn21e7645db487',
    'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
  };
//Fetch and capitalize body parts
  Future<List<String>> fetchAndCapitalizeBodyParts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bodyPartList'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<String> bodyParts = List<String>.from(json.decode(response.body));
      return bodyParts.map((part) => part[0].toUpperCase() + part.substring(1)).toList();
    } else {
      throw Exception('Failed to load body parts');
    }
  }
  //Fetch exercises by name
  Future<List<Workout>> fetchExercisesByName(String name, {int limit = 25, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/name/$name?limit=$limit&offset=$offset'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.asMap().entries.map<Workout>((entry) {
        int index = entry.key; // This gives you the order
        Map<String, dynamic> json = entry.value;
        return Workout.fromJson(json, index + 1); // Pass index as exerciseOrder, adjusted to be 1-based
      }).toList();
    } else {
      print('Failed to load exercises by name');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

//Fetch exercises by body part
  Future<List<Workout>> fetchExercisesByBodyPart(String bodyPart, {int limit = 25, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bodyPart/$bodyPart?limit=$limit&offset=$offset'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.asMap().entries.map<Workout>((entry) {
        int index = entry.key; // Get the index
        Map<String, dynamic> json = entry.value;
        return Workout.fromJson(json, index + 1); // Pass the index as exerciseOrder, adjusted to start from 1
      }).toList();
    } else {
      print('Failed to load exercises');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load exercises: ${response.statusCode} ${response.reasonPhrase}');
    }
  }


//Fetch list of available equipment and capitalize
  Future<List<String>> fetchEquipments() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/equipmentList'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<String> equipments = List<String>.from(json.decode(response.body));
      return equipments.map((equipment) => equipment[0].toUpperCase() + equipment.substring(1)).toList();
    } else {
      throw Exception('Failed to load equipment list');
    }
  }

//Fetch list of available target muscles and capitalize
  Future<List<String>> fetchTargetMuscles() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/targetList'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<String> targetMuscles = List<String>.from(json.decode(response.body));
      return targetMuscles.map((muscle) => muscle[0].toUpperCase() + muscle.substring(1)).toList();
    } else {
      throw Exception('Failed to load target muscle list');
    }
  }

}

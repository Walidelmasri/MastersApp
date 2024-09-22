import 'package:apptrial3/models/setmodel.dart';
//model is designed based on api in order to fetch different exercises
class Workout {
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String id;
  final String name;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  List<SetDetail> sets;

  Workout({
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.id,
    required this.name,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
    this.sets = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json, int exerciseOrder) {
    return Workout(
      bodyPart: json['bodyPart'],
      equipment: json['equipment'],
      gifUrl: json['gifUrl'],
      id: json['id'],
      name: json['name'],
      target: json['target'],
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      instructions: List<String>.from(json['instructions']),
      sets: json.containsKey('sets')
          ? (json['sets'] as List<dynamic>).map((setJson) => SetDetail.fromJson(setJson)).toList()
          : [], // Provide an empty list if 'sets' is not present
    );
  }
//When user adds new set to a workout this function is called so as
//to add different set details
  void addSet() {
    sets.add(SetDetail());
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'id': id,
      'name': name,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'sets': sets.map((set) => set.toJson()).toList(), // Convert each SetDetail to JSON
    };
  }
}

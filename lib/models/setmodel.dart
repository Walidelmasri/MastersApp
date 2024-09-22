//Used in creating and deleting the sets for workouts
//Each workout will have a number of sets, and each will have its own
//sets and reps
class SetDetail {
  int reps;
  double weight;

  SetDetail({this.reps = 0, this.weight = 0.0});

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }

  factory SetDetail.fromJson(Map<String, dynamic> json) {
    return SetDetail(
      reps: json['reps'] ?? 0,
      weight: json['weight']?.toDouble() ?? 0.0,
    );
  }
}

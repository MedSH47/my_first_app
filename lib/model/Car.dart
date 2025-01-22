enum RPM { X4, X5, X6, X7, X8, X9, X10 }

class Car {
  final String? id;
  final String marque;
  final String model;
  final int kilometredistance;
  final int maxspeed;
  final String year;
  final RPM enginerpm;
  final int horsepower;
  final List<String> problems;
  final int essence;
  final int gear;
  final double suspensionsystem;

  Car({
   this.id,
    required this.marque,
    required this.model,
    required this.kilometredistance,
    required this.maxspeed,
    required this.year,
    required this.enginerpm,
    required this.horsepower,
    required this.problems,
    required this.essence,
    required this.gear,
    required this.suspensionsystem,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      marque: json['marque'],
      model: json['model'],
      kilometredistance: json['kilometredistance'],
      maxspeed: json['maxspeed'],
      year: json['year'],
      enginerpm: RPM.values.firstWhere((e) => e.toString() == 'RPM.${json['enginerpm']}'),
      horsepower: json['horsepower'],
      problems: List<String>.from(json['problems']),
      essence: json['essence'],
      gear: json['gear'],
      suspensionsystem: json['suspensionsystem'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marque': marque,
      'model': model,
      'kilometredistance': kilometredistance,
      'maxspeed': maxspeed,
      'year': year,
      'enginerpm': enginerpm.toString().split('.').last,
      'horsepower': horsepower,
      'problems': problems,
      'essence': essence,
      'gear': gear,
      'suspensionsystem': suspensionsystem,
    };
  }
}

class Plant {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String name;
  final String? desciption;
  final String? idPlantCategory;

  Plant({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.name,
    this.desciption,
    required this.idPlantCategory,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        name: json["name"],
        desciption: json["desciption"],
        idPlantCategory: json["id_plant_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "name": name,
        "desciption": desciption,
        "id_plant_category": idPlantCategory,
      };
}

class PlantType {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String name;
  final String? description;

  PlantType({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.name,
    this.description,
  });

  factory PlantType.fromJson(Map<String, dynamic> json) => PlantType(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "name": name,
        "description": description,
      };
}

class PlantCondition {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String name;
  final String? description;

  PlantCondition({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.name,
    this.description,
  });

  factory PlantCondition.fromJson(Map<String, dynamic> json) => PlantCondition(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "name": name,
        "description": description,
      };
}

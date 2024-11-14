import 'dart:io';

class ImageLocal {
  final String idPlant;
  final String idPlantType;
  final String idCondition;
  final String? description;
  final String idImage;
  final String? id;
  final DateTime? createdAt;
  File? imageFile;
  bool? uploaded;

  ImageLocal({
    required this.idPlant,
    required this.idPlantType,
    required this.idCondition,
    required this.description,
    required this.idImage,
    required this.id,
    required this.createdAt,
    this.imageFile,
    this.uploaded,
  });

  factory ImageLocal.fromJson(Map<String, dynamic> json) => ImageLocal(
        idPlant: json["id_plant"],
        idPlantType: json["id_plant_type"],
        idCondition: json["id_condition"],
        description: json["description"],
        idImage: json["id_image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        uploaded: json["uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "id_plant": idPlant,
        "id_plant_type": idPlantType,
        "id_condition": idCondition,
        "description": description,
        "id_image": idImage,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "uploaded": uploaded,
      };
}

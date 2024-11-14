class ImageApp {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String name;
  final String filename;
  final String extFile;
  final String downloadUri;
  final String status;
  final bool active;

  ImageApp({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.name,
    required this.filename,
    required this.extFile,
    required this.downloadUri,
    required this.status,
    required this.active,
  });

  factory ImageApp.fromJson(Map<String, dynamic> json) => ImageApp(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        name: json["name"],
        filename: json["filename"],
        extFile: json["ext_file"],
        downloadUri: json["download_uri"],
        status: json["status"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "name": name,
        "filename": filename,
        "ext_file": extFile,
        "download_uri": downloadUri,
        "status": status,
        "active": active,
      };
}

class ImageDetail {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String idPlant;
  final String idPlantType;
  final String idCondition;
  final String? description;
  final ImageApp? idImage;

  ImageDetail({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.idPlant,
    required this.idPlantType,
    required this.idCondition,
    required this.description,
    this.idImage,
  });

  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        idPlant: json["id_plant"],
        idPlantType: json["id_plant_type"],
        idCondition: json["id_condition"],
        description: json["description"],
        idImage: json["id_image"] == null
            ? null
            : ImageApp.fromJson(json["id_image"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "id_plant": idPlant,
        "id_plant_type": idPlantType,
        "id_condition": idCondition,
        "description": description,
        "id_image": idImage?.toJson(),
      };
}

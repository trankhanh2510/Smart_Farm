class UploadResponse {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String name;
  final String filename;
  final String extFile;
  final String downloadUri;
  final String status;
  final bool active;

  UploadResponse({
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

  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
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

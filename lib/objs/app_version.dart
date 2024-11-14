class AppVersion {
  final String id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String versionName;
  final String idFile;
  final String urlDownloadFile;
  final bool release;
  final String? description;

  AppVersion({
    required this.id,
    this.createdAt,
    this.modifiedAt,
    required this.versionName,
    required this.idFile,
    required this.urlDownloadFile,
    required this.release,
    this.description,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        versionName: json["version_name"],
        idFile: json["id_file"],
        urlDownloadFile: json["url_download_file"],
        release: json["release"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "version_name": versionName,
        "id_file": idFile,
        "url_download_file": urlDownloadFile,
        "release": release,
        "description": description,
      };
}

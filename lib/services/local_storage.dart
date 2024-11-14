import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid.dart';

class LocalStorage {
  Box box;
  LocalStorage({
    required this.box,
  });

  static Future<LocalStorage> init(String name) async {
    Box box = await Hive.openBox(name);
    return LocalStorage(box: box);
  }

  Future<void> insert(Map<String, dynamic> data, {String? id}) async {
    if (id != null) {
      data['id'] = id;
    }
    if (data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    await box.put(data['id'], data);
  }

  List<dynamic> read() {
    return box.values.toList();
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await box.put(id, data);
  }

  Future<void> delete(String? id) async {
    await box.delete(id);
  }
}

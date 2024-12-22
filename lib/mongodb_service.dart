import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  final Db db;
  late final DbCollection collection;
  bool _isOpen = false;

  MongoDBService(String uri)
      : db = Db(uri);

  Future<void> open(String collectionName) async {
    await db.open();
    collection = db.collection(collectionName);
    _isOpen = true;
  }

  Future<void> close() async {
    await db.close();
    _isOpen = false;
  }

  Future<List<Map<String, dynamic>>> readEntries() async {
    if (!_isOpen) {
      throw Exception('Database is not open');
    }
    return await collection.find().toList();
  }

  Future<void> writeEntry(Map<String, dynamic> entry) async {
    if (!_isOpen) {
      throw Exception('Database is not open');
    }
    await collection.insert(entry);
  }
}
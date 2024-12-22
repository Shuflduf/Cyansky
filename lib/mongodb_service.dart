import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  final Db db;
  late final DbCollection collection;

  MongoDBService(String uri, String s)
      : db = Db(uri);

  Future<void> open(String collectionName) async {
    await db.open();
    collection = db.collection(collectionName);
  }

  Future<void> close() async {
    await db.close();
  }

  Future<List<Map<String, dynamic>>> readEntries() async {
    return await collection.find().toList();
  }

  Future<void> writeEntry(Map<String, dynamic> entry) async {
    await collection.insert(entry);
  }
}
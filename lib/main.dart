import 'package:flutter/material.dart';
import 'mongodb_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MongoDBService mongoDBService = MongoDBService(
    dotenv.env['MONGODB_URI']!,
    dotenv.env['MONGODB_COLLECTION']!,
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MongoDB Flutter Example'),
        ),
        body: FutureBuilder(
          future: mongoDBService.open(dotenv.env['MONGODB_DATABASE']!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return EntryList(mongoDBService: mongoDBService);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class EntryList extends StatelessWidget {
  final MongoDBService mongoDBService;

  const EntryList({super.key, required this.mongoDBService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mongoDBService.readEntries(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final entries = snapshot.data!;
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(entries[index]['title'] ?? 'No Title'),
                  subtitle: Text(entries[index]['description'] ?? 'No Description'),
                );
              },
            );
          } else {
            return Center(child: Text('No entries found'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'mongodb_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MongoDBService mongoDBService = MongoDBService(
    dotenv.env['MONGO_URI']!,
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
          future: mongoDBService.open(dotenv.env['COLLECTION_NAME']!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return EntryForm(mongoDBService: mongoDBService);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class EntryForm extends StatefulWidget {
  final MongoDBService mongoDBService;

  const EntryForm({super.key, required this.mongoDBService});

  @override
  EntryFormState createState() => EntryFormState();
}

class EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final entry = {
        'title': _titleController.text,
        'description': _descriptionController.text,
      };
      try {
        await widget.mongoDBService.writeEntry(entry);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Entry added successfully')),
          );
          setState(() {}); // Refresh the list of entries
        }
        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: widget.mongoDBService.readEntries(),
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
            ),
          ),
        ],
      ),
    );
  }
}
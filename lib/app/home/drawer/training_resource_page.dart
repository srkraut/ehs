import 'dart:io';

import 'package:ehs/app/home/models/firebase_file.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:ehs/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'account_page.dart';

class TrainingResource extends StatefulWidget {
  const TrainingResource({Key? key}) : super(key: key);

  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.training, (Route<dynamic> route) => false);
  }

  @override
  State<TrainingResource> createState() => _TrainingResourceState();
}

class _TrainingResourceState extends State<TrainingResource> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('Training resources'),
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading files'),
                );
              } else {
                final files = snapshot.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: files!.length,
                        itemBuilder: (context, index) {
                          final file = files[index];

                          return ListTile(
                            title: Text(
                              file.name,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.file_download),
                              onPressed: () async {
                                await FirebaseApi.downloadFile(file.ref);

                                final snackBar = SnackBar(
                                  content: Text('Downloaded ${file.name}'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}

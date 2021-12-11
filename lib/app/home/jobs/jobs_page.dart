import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ehs/app/home/job_entries/job_entries_page.dart';
import 'package:ehs/app/home/jobs/edit_job_page.dart';
import 'package:ehs/app/home/jobs/job_list_tile.dart';
import 'package:ehs/app/home/jobs/list_items_builder.dart';
import 'package:ehs/app/home/models/job.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:ehs/app/top_level_providers.dart';
import 'package:ehs/constants/strings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:ehs/services/firestore_database.dart';

final jobsStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(databaseProvider)!;
  return database.jobsStream();
});

// watch database
class JobsPage extends ConsumerWidget {
  Future<void> _delete(BuildContext context, WidgetRef ref, Job job) async {
    try {
      final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
      await database.deleteJob(job);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.jobs),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditJobPage.show(context),
          ),
        ],
      ),
      body: _buildContents(context, ref),
    );
  }

  Widget _buildContents(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobsStreamProvider);
    return ListItemsBuilder<Job>(
      data: jobsAsyncValue,
      itemBuilder: (context, job) => Dismissible(
        key: Key('job-${job.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _delete(context, ref, job),
        child: JobListTile(
          job: job,
          onTap: () => JobEntriesPage.show(context, job),
        ),
      ),
    );
  }
}

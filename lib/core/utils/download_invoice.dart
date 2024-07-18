import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';

Future<void> startDownloadInvoice({
  required Invoice invoice,
  required void Function(bool) isTimerTrigger,
  required void Function(bool) fileDownloading,
  required void Function(Timer) getTimer,
  required ScaffoldMessengerState scaffoldMessenger,
}) async {
  try {
    fileDownloading(true);

    // Enqueue the download task
    final taskId = await FlutterDownloader.enqueue(
      url: '${Env.serverUrl}${invoice.url}',
      savedDir: '/storage/emulated/0/Download/',
      fileName: invoice.name.split('.').first,
      saveInPublicStorage: true,
    );

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Download started!'),
      ),
    );

    Timer timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskId'",
        
      );

      if (tasks != null && tasks.isNotEmpty) {
        final status = tasks.first.status;

        if (status == DownloadTaskStatus.complete) {
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Download completed!')),
            );
          fileDownloading(false);
          timer.cancel();
        } else if (status == DownloadTaskStatus.failed) {
          debugPrint(tasks.toString());
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Download failed!')),
            );
          fileDownloading(false);
          timer.cancel();
        }
      }
    });

    getTimer(timer);
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('An error occurred while downloading.')),
    );
  } finally {
    isTimerTrigger(true);
  }
}

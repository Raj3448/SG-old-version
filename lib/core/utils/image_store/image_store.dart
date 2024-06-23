
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;


Future<File> saveImageToDirectory(File imageFile) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');
    return storageResponse;
  }
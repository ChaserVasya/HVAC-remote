import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'stage.dart';

class FileManager {
  FileManager._();

  static const _fileExtension = 'json';
  static final _dataPath = getTemporaryDirectory().then((v) => '${v.path}\\project\\data');

  static Future<List<File>> getFiles(Stage stage) async {
    final stagePath = await _getStagePath(stage);
    final stepDuration = stage.fileStep.toDuration();

    final filesList = List.generate(
      stage.filesAmount,
      (i) {
        final dateTime = Stage.refPoint.add(stepDuration * i);
        return File('$stagePath\\${dateTime.toWindowsSafeFormat()}.$_fileExtension')..createSync(recursive: true);
      },
      growable: false,
    );
    return filesList;
  }

  static Future<String> _getStagePath(Stage stage) async {
    final stageFolder = stage.valueStep.value;
    return '${await _dataPath}\\$stageFolder';
  }

  static Future<void> cleanData() async {
    final dir = Directory(await _dataPath);

    if (!dir.path.contains(RegExp('data'))) throw Exception();

    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

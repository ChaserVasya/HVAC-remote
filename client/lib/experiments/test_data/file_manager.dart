import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'stage.dart';

class FileManager {
  FileManager._();

  static const _fileExtension = 'json';
  static final _dataPath = getExternalStorageDirectory().then(
    (dir) => '${dir!.path}${separator}data',
  );
  static Future<String> get dataPath => _dataPath;
  static final separator = Platform.pathSeparator;

  static Future<bool> checkPathCorrectness() async {
    final path = await dataPath;
    print(path);
    final isEscaping = separator == '\\';
    return path.contains(RegExp('${separator * ((isEscaping) ? 2 : 1)}data'));
  }

  static DateTime timeStampOf(File file) {
    return DateTime.parse(basenameWithoutExtension(file.path));
  }

  static Future<List<File>> getFiles(Stage stage, [int startIndex = 0, int? endIndex]) async {
    endIndex ??= stage.filesAmount - 1;
    final stagePath = await _getStagePath(stage);

    final filesList = List.generate(
      endIndex - startIndex + 1,
      (i) {
        final dateTime = stage.getFileTimeStamp(i + startIndex).toWindowsSafeFormat();
        final path = '$stagePath$separator$dateTime.$_fileExtension';
        return File(path)..createSync(recursive: true);
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

    if (!await checkPathCorrectness()) throw Exception();

    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

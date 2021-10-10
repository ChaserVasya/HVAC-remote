import 'dart:convert';

import 'dart:io';

class IOJson {
  IOJson._();

  static Future<List<T>> read<T>(File file) async {
    final str = await file.readAsString();
    final List json = jsonDecode(str);
    final values = json.cast<T>();
    return values;
  }

  static Future<void> write(File file, List list) async {
    await file.writeAsString(jsonEncode(list));
  }

  static Future<List<T>> readAndMerge<T>(Iterable<File> files) async {
    List<T> merged = [];
    for (var file in files) {
      merged += await read(file);
    }
    return merged;
  }
}

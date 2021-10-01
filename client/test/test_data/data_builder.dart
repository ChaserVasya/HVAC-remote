import 'averager.dart';
import 'file_manager.dart';
import 'int_random.dart';
import 'io_json.dart';
import 'stage.dart';

class DataBuilder {
  DataBuilder._();

  static Future<void> build() async {
    await _buildBasicStageData();
    await _buildRestStages();
  }

  static Future<void> _buildBasicStageData() async {
    final intGenerator = SimplifiedIntRandom();
    final baseStage = stages.last;

    final files = await FileManager.getFiles(baseStage);

    for (var i = 0; i < files.length; i++) {
      print('${baseStage.valueStep.value} generated');
      final dayData = List.generate(
        baseStage.valuesPerFile,
        (_) => intGenerator.next(),
        growable: false,
      );
      await IOJson.write(files[i], dayData);
    }
  }

  static Future<void> _buildStageFromStage(Stage source, Stage target) async {
    final sourcefiles = await FileManager.getFiles(source);
    final targetFiles = await FileManager.getFiles(target);

    final filesPerMerge = source.filesAmount ~/ target.filesAmount;

    for (var i = 0; i < targetFiles.length; i++) {
      print('${source.valueStep.value} to ${target.valueStep.value}');

      late final List<int> sourceValues;
      if (filesPerMerge == 1) {
        sourceValues = await IOJson.read(sourcefiles[i]);
      } else {
        final files = sourcefiles.getRange(i * filesPerMerge, (i + 1) * filesPerMerge);
        sourceValues = await IOJson.readAndMerge(files);
      }

      final targetValues = Averager.reduceByAveraging(target.valuesPerFile, sourceValues);
      await IOJson.write(targetFiles[i], targetValues);
    }
  }

  static Future<void> _buildRestStages() async {
    for (var i = TimeSteps.values.length - 1; i > 0; i--) {
      await _buildStageFromStage(stages[i], stages[i - 1]);
    }
  }
}

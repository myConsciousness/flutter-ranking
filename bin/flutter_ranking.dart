import 'dart:io';

import 'package:flutter_ranking/file_writer.dart' as writer;
import 'package:flutter_ranking/ranking.dart' as ranking;
import 'package:flutter_ranking/ranking_type.dart';
import 'package:intl/intl.dart';

void main(List<String> arguments) async {
  final rankingType = RankingType.valueOf(
    Platform.environment['RANKING_TYPE'] ?? '',
  );

  final packages = await ranking.getListedPackages(
    query: rankingType.query,
    maxResults: rankingType.maxResults,
  );

  final now = DateTime.now().toUtc();
  final today = DateFormat('yyyy-MM-dd').format(now);

  final historyFolder = Directory('./history/${rankingType.fileName}/$today');
  if (!historyFolder.existsSync()) {
    historyFolder.createSync(recursive: true);
  }

  await writer.writeHistoryFile(
    File(
      './history/${rankingType.fileName}/$today/${now.toUtc().toIso8601String()}.tsv',
    ),
    packages,
    now,
  );

  await writer.writeResultFile(
    rankingType,
    File('./results/${rankingType.fileName}.md'),
    packages,
    now,
  );

  if (rankingType == RankingType.flutter) {
    await writer.writeResultFile(
      rankingType,
      File('README.md'),
      packages,
      now,
    );
  }
}

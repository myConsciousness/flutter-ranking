import 'dart:io';

import 'package:flutter_ranking/file_writer.dart' as writer;
import 'package:flutter_ranking/ranking.dart' as ranking;
import 'package:flutter_ranking/ranking_type.dart';

void main(List<String> arguments) async {
  final now = DateTime.now().toUtc();

  final rankingType = RankingType.valueOf(
    Platform.environment['RANKING_TYPE'] ?? '',
  );

  final packages = await ranking.getListedPackages(
    query: rankingType.query,
    maxResults: rankingType.maxResults,
  );

  writer.writeResultFile(
    rankingType,
    File('./results/${rankingType.fileName}.md'),
    packages,
    now,
  );

  writer.writeMetrics(rankingType, packages);
  writer.writeMetricsEachOwners(rankingType, now);

  if (rankingType == RankingType.all) {
    writer.writeResultFile(
      rankingType,
      File('README.md'),
      packages,
      now,
    );
  }
}

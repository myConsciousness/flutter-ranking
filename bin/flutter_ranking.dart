import 'dart:io';

import 'package:flutter_ranking/ranking.dart' as ranking;
import 'package:flutter_ranking/package.dart';
import 'package:flutter_ranking/tsv_record.dart';

void main(List<String> arguments) async {
  print(Platform.environment);
  final packages = await ranking.getListedPackages();
  final now = DateTime.now();

  await _writeHistoryFile(packages, now);
}

Future<void> _writeHistoryFile(
  final List<Package> packages,
  final DateTime now,
) async {
  final historyFile = File('./history/${now.toUtc().toIso8601String()}.tsv');

  _write(
    historyFile,
    TsvRecord()
      ..addValue('No.')
      ..addValue('Name')
      ..addValue('Description')
      ..addValue('Version')
      ..addValue('Popularity')
      ..addValue('Likes')
      ..addValue('Stars')
      ..addValue('Forks')
      ..addValue('Issues')
      ..addValue('Owner')
      ..addValue('Publisher')
      ..addValue('License')
      ..addValue('Last Commit'),
  );

  int rank = 1;
  for (final package in packages) {
    _write(
      historyFile,
      TsvRecord()
        ..addValue('$rank')
        ..addValue(package.name)
        ..addValue(package.description)
        ..addValue(package.version)
        ..addValue('${package.popularity}')
        ..addValue('${package.likeCount}')
        ..addValue('${package.likeCount}')
        ..addValue('${package.forkCount}')
        ..addValue('${package.issueCount}')
        ..addValue(package.owner)
        ..addValue(package.publisher)
        ..addValue(package.license)
        ..addValue(package.updatedAt.toIso8601String()),
    );

    rank++;
  }
}

void _write(final File file, final TsvRecord record) =>
    file.writeAsStringSync(record.toString(), mode: FileMode.append);

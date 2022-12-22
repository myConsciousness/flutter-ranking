import 'dart:convert';
import 'dart:io';

import 'package:flutter_ranking/file_title.dart';
import 'package:flutter_ranking/ranking_type.dart';

import 'package.dart';
import 'record.dart';
import 'table_record.dart';
import 'tsv_record.dart';

void writeHistoryFile(
  final File file,
  final List<Package> packages,
  final DateTime now,
) {
  _write(
    file,
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
      ..addValue('Last Commit')
      ..addValue('Repository URL'),
  );

  int rank = 1;
  for (final package in packages) {
    _write(
      file,
      TsvRecord()
        ..addValue('$rank')
        ..addValue(package.name)
        ..addValue(package.description)
        ..addValue(package.version)
        ..addValue('${package.popularity}')
        ..addValue('${package.likeCount}')
        ..addValue('${package.starCount}')
        ..addValue('${package.forkCount}')
        ..addValue('${package.issueCount}')
        ..addValue(package.owner)
        ..addValue(package.publisher)
        ..addValue(package.license)
        ..addValue(package.updatedAt.toUtc().toIso8601String())
        ..addValue(package.repositoryUrl),
    );

    rank++;
  }
}

void writeResultFile(
  final RankingType type,
  final File file,
  final List<Package> packages,
  final DateTime now,
) {
  file.writeAsStringSync(getTitle(type, now));

  _write(
    file,
    TableRecord()
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

  _write(
    file,
    TableRecord()
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---')
      ..addValue('---'),
  );

  int rank = 1;
  for (final package in packages) {
    _write(
      file,
      TableRecord()
        ..addValue('**$rank**')
        ..addValue(
            '[${package.name}](https://pub.dev/packages/${package.name})')
        ..addValue(package.description)
        ..addValue(
            '[${package.version}](https://pub.dev/packages/${package.name}/versions)')
        ..addValue(
            '${package.popularity == -1 ? 'N/A' : package.popularity.toStringAsFixed(5)}%')
        ..addValue('${package.likeCount}')
        ..addValue('${package.starCount}')
        ..addValue('${package.forkCount}')
        ..addValue('[${package.issueCount}](${package.repositoryUrl}/issues)')
        ..addValue('[@${package.owner}](https://github.com/${package.owner})')
        ..addValue(
            '[${package.publisher}](https://pub.dev/publishers/${package.publisher}/packages)')
        ..addValue(package.license)
        ..addValue(package.updatedAt.toUtc().toIso8601String()),
    );

    rank++;
  }
}

void writeMetrics(
  final List<Package> packages,
) {
  final latestMetricsFile = File('./metrics/__latest__.json');
  final Map<String, dynamic> metrics = jsonDecode(
    latestMetricsFile.readAsStringSync(),
  );

  int rank = 1;
  for (final package in packages) {
    if (metrics.containsKey(package.owner)) {
      metrics[package.owner][package.name] = _getMetrics(rank, package);
    } else {
      metrics[package.owner] = {package.name: _getMetrics(rank, package)};
    }

    rank++;
  }

  latestMetricsFile.writeAsStringSync(jsonEncode(metrics));
}

void writeMetricsEachOwners(final DateTime now) {
  final latestMetricsFile = File('./metrics/__latest__.json');
  final Map<String, dynamic> latestMetrics = jsonDecode(
    latestMetricsFile.readAsStringSync(),
  );

  latestMetrics.forEach((owner, packages) {
    final ownerFile = File('./metrics/$owner.json');

    if (ownerFile.existsSync()) {
      final ownerJson = jsonDecode(ownerFile.readAsStringSync());
      ownerJson[now.toIso8601String()] = latestMetrics[owner];

      ownerFile.writeAsStringSync(jsonEncode(ownerJson));
    } else {
      ownerFile.createSync(recursive: true);

      ownerFile.writeAsStringSync(
        jsonEncode(
          {now.toIso8601String(): latestMetrics[owner]},
        ),
      );
    }
  });
}

Map<String, dynamic> _getMetrics(final int rank, final Package package) => {
      'rank': rank,
      'repository': package.repositoryUrl,
      'popularity': package.popularity,
      'like_count': package.likeCount,
      'star_count': package.starCount,
      'fork_count': package.forkCount,
      'issue_count': package.issueCount,
      'publisher': package.publisher,
    };

void _write(final File file, final Record record) =>
    file.writeAsStringSync(record.toString(), mode: FileMode.append);

import 'dart:io';

import 'package:flutter_ranking/ranking.dart' as ranking;
import 'package:flutter_ranking/package.dart';
import 'package:flutter_ranking/record.dart';
import 'package:flutter_ranking/table_record.dart';
import 'package:flutter_ranking/tsv_record.dart';

void main(List<String> arguments) async {
  final packages = await ranking.getListedPackages();

  final now = DateTime.now();
  await _writeHistoryFile(packages, now);
  await _writeReadmeFile(packages, now);
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
      ..addValue('Last Commit')
      ..addValue('Repository URL'),
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

void _write(final File file, final Record record) =>
    file.writeAsStringSync(record.toString(), mode: FileMode.append);

Future<void> _writeReadmeFile(
  final List<Package> packages,
  final DateTime now,
) async {
  final readmeFile = File('README.md')..writeAsStringSync('');

  readmeFile.writeAsStringSync(
      '''[![GitHub Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4)](https://github.com/sponsors/myConsciousness)
[![GitHub Sponsor](https://img.shields.io/static/v1?label=Maintainer&message=myConsciousness&logo=GitHub&color=00acee)](https://github.com/myConsciousness)

# Flutter Ranking 👑✨

I respect all OSS developers who are developing great packages! 🫡

This project aims to visualize the ranking of OSS packages published on [pub.dev](https://pub.dev) to further invigorate the community and promote competition.

Currently, the top 1,024 packages are listed in this ranking, sorted by popularity index as evaluated by [pub.dev](https://pub.dev). This process is fully automated and ranking is recalculated daily per 3 hours based on UTC time ✨

**Show some ❤️ and star the repo to support the project!**

> **Notification:**</br>
> Last Updated (UTC): ${now.toUtc().toIso8601String()}

## Content 🎉

''');

  _write(
    readmeFile,
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
    readmeFile,
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
      readmeFile,
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

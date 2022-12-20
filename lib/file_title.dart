import 'package:flutter_ranking/ranking_type.dart';

String getTitle(
  final RankingType type,
  final DateTime now,
) =>
    '''[![GitHub Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4)](https://github.com/sponsors/myConsciousness)
[![GitHub Sponsor](https://img.shields.io/static/v1?label=Maintainer&message=myConsciousness&logo=GitHub&color=00acee)](https://github.com/myConsciousness)

# ✨👑 ${_getH1Title(type)} 👑✨

I respect all OSS developers who are developing great packages! 🫡

This project aims to visualize the ranking of OSS packages published on [pub.dev](https://pub.dev) to further invigorate the community and promote competition.

Currently, the top ${_getPackageCount(type)} packages are listed in this ranking, sorted by popularity index as evaluated by [pub.dev](https://pub.dev). This process is fully automated and ranking is recalculated everyday between 06:00 and 07:00 based on UTC time ✨

**Show some ❤️ and star the repo to support the project!**

- [Ranking for All Flutter Packages](https://github.com/myConsciousness/flutter-ranking/blob/main/results/flutter.md)
- [Ranking for Flutter Widgets](https://github.com/myConsciousness/flutter-ranking/blob/main/results/flutter_widget.md)
- [Ranking for Dart Packages exclude Widgets](https://github.com/myConsciousness/flutter-ranking/blob/main/results/dart_only.md)

> **Warning**</br>
> Packages that meet the following criteria will not be listed.
> </br>
> - Repository URL does not specified in `pubspec.yaml` or invalid URL.</br>
> - License does not exist.</br>
> - Description does not exist.

> **Notification:**</br>
> Last Updated (UTC): ${now.toUtc().toIso8601String()}

## ${_getH2Title(type)} 🎉🎉

''';

String _getH1Title(final RankingType type) {
  switch (type) {
    case RankingType.all:
      return 'Flutter Ranking';
    case RankingType.onlyFlutterWidget:
      return 'Flutter Widget Ranking';
    case RankingType.excludeFlutterWidget:
      return 'Dart Ranking';
  }
}

String _getH2Title(final RankingType type) {
  switch (type) {
    case RankingType.all:
      return 'All Flutter Packages';
    case RankingType.onlyFlutterWidget:
      return 'Flutter Widgets';
    case RankingType.excludeFlutterWidget:
      return 'Dart Packages';
  }
}

String _getPackageCount(final RankingType type) {
  switch (type) {
    case RankingType.all:
      return '1,024';
    case RankingType.onlyFlutterWidget:
    case RankingType.excludeFlutterWidget:
      return '512';
  }
}

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

Currently, the top ${_getPackageCount(type)} packages are listed in this ranking, sorted by popularity index as evaluated by [pub.dev](https://pub.dev). This process is fully automated and ranking is recalculated daily per 2 hours based on UTC time ✨

**Show some ❤️ and star the repo to support the project!**

- [Ranking for All Flutter Packages](https://github.com/myConsciousness/flutter-ranking/blob/main/results/flutter.md)
- [Ranking for Flutter Widgets](https://github.com/myConsciousness/flutter-ranking/blob/main/results/flutter_widget.md)

> **Notification:**</br>
> Last Updated (UTC): ${now.toUtc().toIso8601String()}

## ${_getH2Title(type)} 🎉🎉

''';

String _getH1Title(final RankingType type) {
  switch (type) {
    case RankingType.flutter:
      return 'Flutter Ranking';
    case RankingType.flutterWidget:
      return 'Flutter Ranking for Flutter Widgets';
  }
}

String _getH2Title(final RankingType type) {
  switch (type) {
    case RankingType.flutter:
      return 'Flutter Packages';
    case RankingType.flutterWidget:
      return 'Flutter Widgets';
  }
}

String _getPackageCount(final RankingType type) {
  switch (type) {
    case RankingType.flutter:
      return '1,024';
    case RankingType.flutterWidget:
      return '512';
  }
}

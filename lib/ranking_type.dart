enum RankingType {
  all('', 1024, 'flutter'),
  onlyFlutterWidget('-sdk:dart sdk:flutter', 512, 'flutter_widget'),
  excludeFlutterWidget('sdk:dart sdk:flutter', 512, 'dart_only');

  /// The search query.
  final String query;

  /// The max results to search.
  final int maxResults;

  /// The file name to write result.
  final String fileName;

  const RankingType(
    this.query,
    this.maxResults,
    this.fileName,
  );

  static RankingType valueOf(final String code) {
    switch (code) {
      case 'all':
        return all;
      case 'only_flutter_widget':
        return onlyFlutterWidget;
      case 'exclude_flutter_widget':
        return excludeFlutterWidget;
      default:
        throw UnsupportedError('Unsupported type [$code]');
    }
  }
}

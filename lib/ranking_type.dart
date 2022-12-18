enum RankingType {
  flutter('sdk:dart sdk:flutter', 1024, 'flutter'),
  flutterWidget('-sdk:dart sdk:flutter', 512, 'flutter_widget');

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
      case 'flutter':
        return flutter;
      case 'flutterWidget':
        return flutterWidget;
      default:
        throw UnsupportedError('Unsupported type [$code]');
    }
  }
}

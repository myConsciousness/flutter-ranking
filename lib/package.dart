class Package {
  /// Returns the new instance of [Package].
  const Package(
    this.name,
    this.description,
    this.version,
    this.repositoryUrl,
    this.popularity,
    this.likeCount,
    this.starCount,
    this.forkCount,
    this.owner,
    this.ownerAvatarUrl,
    this.issueCount,
    this.publisher,
    this.license,
    this.updatedAt,
  );

  /// The package name.
  final String name;

  /// The description.
  final String description;

  /// The version.
  final String version;

  /// The GitHub repository url.
  final String repositoryUrl;

  /// The popularity.
  final double popularity;

  /// The like count.
  final int likeCount;

  /// The star count.
  final int starCount;

  /// The fork count.
  final int forkCount;

  /// The owner in GitHub repository.
  final String owner;

  /// The avatar url in GitHub.
  final String ownerAvatarUrl;

  /// The issue count.
  final int issueCount;

  /// The publisher of this package.
  final String publisher;

  /// The license.
  final String license;

  /// The updated date time.
  final DateTime updatedAt;
}

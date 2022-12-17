import 'dart:convert';
import 'dart:io';

import 'package:flutter_ranking/package.dart';
import 'package:http/http.dart';
import 'package:pub_api_client/pub_api_client.dart';

final pub = PubClient();
final _bearerToken = Platform.environment['BEARER_TOKEN'];

const _maxCount = 3000;

Future<List<Package>> getListedPackages() async {
  final packages = <Package>[];

  int page = 1;
  while (true) {
    final searchResults = await pub.search(
      '',
      page: page,
      sort: SearchOrder.popularity,
    );

    for (final result in searchResults.packages) {
      if (packages.length >= _maxCount) {
        return packages;
      }

      final packageInfoResponse = await get(
        Uri.parse('https://pub.dartlang.org/api/packages/${result.package}'),
      );

      final packageInfoJson = jsonDecode(packageInfoResponse.body);
      final repository = packageInfoJson['latest']['pubspec']['repository'];

      if (repository == null || !repository.startsWith('https://github.com/')) {
        continue;
      }

      final githubRepository = await _getGitHubRepository(repository);
      if (githubRepository.statusCode != 200) {
        continue;
      }

      final repositoryJson = jsonDecode(githubRepository.body);

      final packageScore = await pub.packageScore(result.package);
      final publisher = await pub.packagePublisher(result.package);

      final license = repositoryJson['license'];
      if (license == null) {
        //! Include only approved package.
        continue;
      }

      final package = Package(
        packageInfoJson['latest']['pubspec']['name'],
        packageInfoJson['latest']['pubspec']['description'],
        packageInfoJson['latest']['pubspec']['version'],
        repository,
        packageScore.popularityScore! * 100,
        packageScore.likeCount,
        repositoryJson['stargazers_count'],
        repositoryJson['forks_count'],
        repositoryJson['owner']['login'],
        repositoryJson['open_issues_count'],
        publisher.publisherId ?? '',
        license['spdx_id'],
        DateTime.parse(repositoryJson['pushed_at']),
      );

      packages.add(package);

      print('Progress: ${((packages.length / _maxCount) * 100) ~/ 1}%');
    }

    page++;
  }
}

String _getOwner(final String repository) {
  if (!repository.startsWith('https://github.com/')) {
    return '';
  }

  final start = repository.indexOf('/', 'https://github.com'.length) + 1;

  if (start == -1) {
    return '';
  }

  return repository.substring(
    start,
    repository.indexOf('/', start),
  );
}

String _getRepositoryName(final String repository) =>
    repository.substring(repository.lastIndexOf('/') + 1);

Future<Response> _getGitHubRepository(final String repository) async {
  final owner = _getOwner(repository);

  final slug = '/repos/$owner/${_getRepositoryName(repository)}';

  return await get(
    Uri.https(
      'api.github.com',
      slug,
    ),
    headers: {'Authorization': 'Bearer $_bearerToken'},
  );
}

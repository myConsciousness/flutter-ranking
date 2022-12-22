import 'dart:convert';
import 'dart:io';

import 'package:flutter_ranking/package.dart';
import 'package:http/http.dart';

Future<List<Package>> getListedPackages({
  required String query,
  required int maxResults,
}) async {
  final packages = <Package>[];

  int page = 1;
  while (true) {
    final searchResults = await get(
      Uri.https(
        'pub.dartlang.org',
        '/api/search',
        {
          'q': query,
          'page': '$page',
          'sort': 'popularity',
        },
      ),
    );

    final searchResultsJson = jsonDecode(searchResults.body);

    for (final result in searchResultsJson['packages']) {
      if (packages.length >= maxResults) {
        return packages;
      }

      final packageName = result['package'];

      final packageInfoResponse = await get(
        Uri.parse('https://pub.dartlang.org/api/packages/$packageName'),
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

      final packageScoreJson = await get(
        Uri.parse(
          'https://pub.dartlang.org/api/packages/$packageName/score',
        ),
      );

      final packageScore = jsonDecode(packageScoreJson.body);

      final publisherJson = await get(
        Uri.parse(
          'https://pub.dartlang.org/api/packages/$packageName/publisher',
        ),
      );

      final publisher = jsonDecode(publisherJson.body);

      final license = repositoryJson['license'];
      if (license == null) {
        //! Include only approved package.
        continue;
      }

      final String? description =
          packageInfoJson['latest']['pubspec']['description'];

      if (description == null) {
        //! Include only package with description.
        continue;
      }

      final package = Package(
        packageInfoJson['latest']['pubspec']['name'],
        description.replaceAll('\n', ''),
        packageInfoJson['latest']['pubspec']['version'],
        repository,
        packageScore['popularityScore'] != null
            ? packageScore['popularityScore'] * 100
            : -1,
        packageScore['likeCount'],
        repositoryJson['stargazers_count'],
        repositoryJson['forks_count'],
        repositoryJson['owner']['login'],
        repository['owner']['avatar_url'],
        repositoryJson['open_issues_count'],
        publisher['publisherId'] ?? '',
        license['spdx_id'],
        DateTime.parse(repositoryJson['pushed_at']),
      );

      packages.add(package);

      print('Progress: ${((packages.length / maxResults) * 100) ~/ 1}%');
    }

    page++;
  }
}

String _getOwner(final String repository) {
  if (!repository.startsWith('https://github.com/')) {
    return '';
  }

  final start = repository.indexOf('/', 'https://github.com'.length) + 1;
  final end = repository.indexOf('/', start);

  return repository.substring(
    start,
    end == -1 ? repository.length : end,
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
    headers: {
      'Authorization': 'Bearer ${Platform.environment['GITHUB_BEARER_TOKEN']}'
    },
  );
}

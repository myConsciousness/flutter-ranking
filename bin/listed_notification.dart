import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

Future<void> main(List<String> args) async {
  final Map<String, dynamic> latestMatrics = _reverse(
    jsonDecode(File('matrics/__latest__.json').readAsStringSync()),
  );

  final notifiedOwnersFile = File('./history/notified_owners.json');
  final Map<String, dynamic> notifiedOwners = jsonDecode(
    notifiedOwnersFile.readAsStringSync(),
  );

  int count = 0;
  latestMatrics.forEach((owner, packages) async {
    if (count >= 2) {
      return;
    }

    if (notifiedOwners.containsKey(owner)) {
      //
    } else {
      final githubUserResponse = await get(
        Uri.https('api.github.com', '/users/$owner'),
        headers: {
          'Authorization':
              'Bearer ${Platform.environment['GITHUB_BEARER_TOKEN']}'
        },
      );

      final githubUser = jsonDecode(githubUserResponse.body);
      final String? twitterUser = githubUser['twitter_username'];

      if (twitterUser != null) {
        final listedPackageNames = _getNewListedPackages(
          packages: latestMatrics[owner],
        );

        await _twitter.tweets.createTweet(
          text: '''Congratulations @kato__shinya!
${_getSentence(listedPackageNames)}

Thanks for your great work for #Flutter community!

https://github.com/myConsciousness/flutter-ranking
''',
        );

        notifiedOwners[owner] = listedPackageNames;

        count++;
      }
    }
  });

  notifiedOwnersFile.writeAsStringSync(
    jsonEncode(notifiedOwners),
  );
}

TwitterApi get _twitter => TwitterApi(
      bearerToken: '',
      oauthTokens: OAuthTokens(
        consumerKey: Platform.environment['TWITTER_CONSUMER_KEY']!,
        consumerSecret: Platform.environment['TWITTER_CONSUMER_SECRET']!,
        accessToken: Platform.environment['TWITTER_ACCESS_TOKEN']!,
        accessTokenSecret: Platform.environment['TWITTER_ACCESS_TOKEN_SECRET']!,
      ),
      retryConfig: RetryConfig(
        maxAttempts: 10,
        onExecute: (event) => print(
          'Retry after ${event.intervalInSeconds} seconds... '
          '[${event.retryCount} times]',
        ),
      ),
    );

Map<String, dynamic> _reverse(Map<String, dynamic> map) =>
    {for (var e in map.entries) e.value: e.key};

List<String> _getNewListedPackages({
  required Map<String, dynamic> packages,
  Map<String, dynamic> notifiedPackages = const {},
}) {
  final packageNames = <String>[];

  packages.forEach((key, value) {
    if (!notifiedPackages.containsKey(key)) {
      packageNames.add(key);
    }
  });

  return packageNames;
}

String _getSentence(final List<String> packageNames) {
  if (packageNames.length > 1) {
    return 'Your packages ${packageNames.join(', ')} are listed in #FlutterRanking! 👑✨';
  }

  return 'Your package ${packageNames[0]} is listed in #FlutterRanking! 👑✨';
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '✨👑 Flutter Ranking 👑✨',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: http.get(
                Uri.https(
                  'raw.githubusercontent.com',
                  '/myConsciousness/flutter-ranking/main/metrics/__latest__.json',
                ),
              ),
              builder: (_, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final Map<String, dynamic> metrics = jsonDecode(
                  snapshot.data.body,
                );

                final ranking = <Map<String, dynamic>>[];
                metrics.forEach((owner, packages) {
                  (packages as Map<String, dynamic>)
                      .forEach((packageName, packageInfo) {
                    ranking.add({
                      'owner': owner,
                      'package_name': packageName,
                      ...packageInfo
                    });
                  });
                });

                ranking.sort((m1, m2) => m1['rank'].compareTo(m2['rank']));

                return ListView.builder(
                  itemCount: ranking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Text(ranking[index].toString()),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
}

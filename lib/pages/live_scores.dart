import 'package:flutter/material.dart';
import 'package:football_scores/services/live_score_service.dart';
import 'package:football_scores/widgets/navigation_drawer.dart'
    as NavigationDrawer;

class LiveScores extends StatelessWidget {
  const LiveScores({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Live Scores"),
        ),
        drawer: const NavigationDrawer.NavigationDrawer(),
        body: LiveScore(),
      );
}

class LiveScore extends StatefulWidget {
  const LiveScore({super.key});

  @override
  State<LiveScore> createState() => _LiveScoreState();
}

class _LiveScoreState extends State<LiveScore> {
  late Future<List<dynamic>> liveScores;

  @override
  void initState() {
    super.initState();
    liveScores = LiveScoreService().getLiveScores();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: liveScores,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.black87,
                    title: Text(
                        snapshot.data![index]['country']['countryNameEnglish'],
                        style: const TextStyle(color: Colors.white),),
                    leading: Image.network(
                      snapshot.data![index]['country']['countryLogoUrl'],
                      height: 30,
                      width: 40,
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }
}

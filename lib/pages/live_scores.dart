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
    return RefreshIndicator(
      onRefresh: () async {
        var result = await LiveScoreService().getLiveScores();
        setState(() {
          liveScores = Future<List<dynamic>>.value(result);
        });
      },
      child: FutureBuilder(
          future: liveScores,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.black87,
                          title: Text(
                            snapshot.data![index]['country']
                                ['countryNameEnglish'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Image.network(
                            snapshot.data![index]['country']['countryLogoUrl'],
                            height: 30,
                            width: 40,
                          ),
                        ),
                        ListView.builder(
                          itemCount: snapshot.data![index]['matches'].length,
                          itemBuilder: (context, matchIndex) {
                            return ListTile(
                              title: Text(snapshot.data![index]['matches']
                                      [matchIndex]['match_hometeam_name'] +
                                  " - " +
                                  snapshot.data![index]['matches'][matchIndex]
                                      ['match_awayteam_name']),
                              subtitle: Text(
                                  "Status: " +
                                      snapshot.data![index]['matches']
                                          [matchIndex]['match_status'] +
                                      "'",
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.notification_add)),
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        )
                      ],
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })),
    );
  }
}

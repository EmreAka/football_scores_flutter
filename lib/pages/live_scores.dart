import 'package:flutter/material.dart';
import 'package:football_scores/models/selected_route.dart';
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
        drawer: NavigationDrawer.NavigationDrawer(selectedRoute: SelectedRoute.liveScores,),
        body: const LiveScore(),
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
                            "${snapshot.data![index]['country']['countryNameEnglish']} ${snapshot.data![index]['leagueName']}",
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
                              title: Row(
                                children: [
                                  Text(
                                      "${snapshot.data![index]['matches'][matchIndex]['match_hometeam_name']} - ${snapshot.data![index]['matches'][matchIndex]['match_awayteam_name']}"),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "Status ${snapshot.data![index]['matches'][matchIndex]['match_status']}'",
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              trailing: Text(
                                "${snapshot.data![index]['matches'][matchIndex]['match_hometeam_score']} vs ${snapshot.data![index]['matches'][matchIndex]['match_awayteam_score']}",
                              ),
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        )
                      ],
                    );
                  });
            } else {
              return const LinearProgressIndicator();
            }
          })),
    );
  }
}

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
        drawer: NavigationDrawer.NavigationDrawer(
          selectedRoute: SelectedRoute.liveScores,
        ),
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
                            "${snapshot.data![index]['country']?['countryNameEnglish'] ?? "Unknown"} - ${snapshot.data![index]['leagueName']}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Image.network(
                            snapshot.data![index]['country']
                                    ?['countryLogoUrl'] ??
                                "https://apiv3.apifootball.com/badges/logo_country/2_intl.png",
                            height: 30,
                            width: 40,
                            errorBuilder: (context, error, stackTrace) => const Text("😒"),
                          ),
                        ),
                        ListView.builder(
                          itemCount: snapshot.data![index]['matches'].length,
                          itemBuilder: (context, matchIndex) {
                            return matchResult(snapshot, index, matchIndex);
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

  Widget matchResult(
      AsyncSnapshot<List<dynamic>> snapshot, int index, int matchIndex) {
    var color = matchIndex % 2 != 0 ? Color.fromARGB(255, 235, 235, 235) : Colors.white;
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: SizedBox(
          height: 50,
          child: Row(children: [
            SizedBox(
              width: 60,
              child: Text(
                "${snapshot.data![index]['matches'][matchIndex]['match_status']}'",
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  "${snapshot.data![index]['matches'][matchIndex]['match_hometeam_name']}",
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Text(
                "${snapshot.data![index]['matches'][matchIndex]['match_hometeam_score']} - ${snapshot.data![index]['matches'][matchIndex]['match_awayteam_score']}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                    "${snapshot.data![index]['matches'][matchIndex]['match_awayteam_name']}"),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notification_add))
          ]),
        ),
      ),
    );
  }
}

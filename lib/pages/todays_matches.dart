import 'package:flutter/material.dart';
import 'package:football_scores/models/selected_route.dart';
import 'package:football_scores/widgets/navigation_drawer.dart' as NavigationDrawer;

import '../services/live_score_service.dart';

class TodaysMatches extends StatelessWidget {
  const TodaysMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer.NavigationDrawer(selectedRoute: SelectedRoute.todaysMatches),
      appBar: AppBar(
        title: const Text("Today's Matches"),
      ),
      body: const Matches(),
    );
    
  }
}

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<StatefulWidget> createState() => _MatchesState();
}

class _MatchesState extends State {
  late Future<List<dynamic>> todayEvents;

  _MatchesState();

  @override
  void initState() {
    super.initState();
    todayEvents = LiveScoreService().getTodaysEvents();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: todayEvents,
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
      }));
  }

  Widget matchResult(
      AsyncSnapshot<List<dynamic>> snapshot, int index, int matchIndex) {
    var color = matchIndex % 2 != 0 ? const Color.fromARGB(255, 235, 235, 235) : Colors.white;
    var isLive = snapshot.data![index]['matches'][matchIndex]['match_live'] == "1" ? true : false;
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
                "${snapshot.data![index]['matches'][matchIndex]['match_time']}'",
                style: TextStyle(color: isLive ? Colors.green : Colors.black),
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
                style: const TextStyle(fontWeight: FontWeight.bold),),
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
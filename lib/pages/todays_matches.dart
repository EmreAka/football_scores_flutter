import 'package:flutter/material.dart';
import 'package:football_scores/models/selected_route.dart';
import 'package:football_scores/widgets/navigation_drawer.dart' as NavigationDrawer;

import '../services/live_score_service.dart';

class TodaysMatches extends StatefulWidget {
  const TodaysMatches({super.key});

  @override
  State<TodaysMatches> createState() => _TodaysMatchesState();
}

class _TodaysMatchesState extends State<TodaysMatches> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text("Today's Matches");
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer.NavigationDrawer(selectedRoute: SelectedRoute.todaysMatches),
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: _controller,
                        onEditingComplete: () => {setState(() {})},
                        decoration: const InputDecoration(
                          hintText: 'Country or league name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text("Today's Matches");
                    _controller.clear();
                  }
                });
              });
            },
            icon: customIcon,
          ),
        ]
      ),
      body: Matches(searchText: _controller.text),
    );
    
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class Matches extends StatefulWidget {
  String searchText;
  Matches({super.key, required this.searchText});

  @override
  State<StatefulWidget> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  late Future<List<dynamic>> todayEvents;

  _MatchesState();

  @override
  void didUpdateWidget(covariant Matches oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchText.isNotEmpty) {
      todayEvents = LiveScoreService().getTodaysEventsBySearch(widget.searchText);
    }else{
      todayEvents = LiveScoreService().getTodaysEvents();
    }
  }

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
      }));
  }

  Widget matchResult(
      AsyncSnapshot<List<dynamic>> snapshot, int index, int matchIndex) {
    var color = matchIndex % 2 != 0 ? Colors.grey[900] : null;
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
                style: TextStyle(color: isLive ? Colors.green : Colors.white),
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
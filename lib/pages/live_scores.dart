import 'package:flutter/material.dart';
import 'package:football_scores/models/selected_route.dart';
import 'package:football_scores/services/live_score_service.dart';
import 'package:football_scores/widgets/navigation_drawer.dart'
    as NavigationDrawer;

class LiveScores extends StatefulWidget {
  const LiveScores({super.key});

  @override
  State<LiveScores> createState() => _LiveScoresState();
}

class _LiveScoresState extends State<LiveScores> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Live Scores');
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
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
                      customSearchBar = const Text('Live Scores');
                      _controller.clear();
                    }
                  });
                });
              },
              icon: customIcon,
            ),
          ],
        ),
        drawer: isMobileSize(context)
            ? NavigationDrawer.NavigationDrawer(
                selectedRoute: SelectedRoute.liveScores,
              )
            : null,
        body: LiveScore(searchText: _controller.text),
      );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class LiveScore extends StatefulWidget {
  String searchText;
  LiveScore({super.key, required this.searchText});

  @override
  State<LiveScore> createState() => _LiveScoreState();
}

class _LiveScoreState extends State<LiveScore> {
  late Future<List<dynamic>> liveScores;

  @override
  void didUpdateWidget(covariant LiveScore oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.searchText.isNotEmpty) {
        liveScores =
            LiveScoreService().getLiveScoresBySearch(widget.searchText);
      } else {
        liveScores = LiveScoreService().getLiveScores();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.searchText.isEmpty) {
      liveScores = LiveScoreService().getLiveScoresBySearch(widget.searchText);
    } else {
      liveScores = LiveScoreService().getLiveScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, x) =>
          x.maxWidth < 1000 ? mobileContent() : desktopContent(),
    );
  }

  Widget desktopContent() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        NavigationDrawer.NavigationDrawer(
            selectedRoute: SelectedRoute.liveScores),
        Expanded(child: mobileContent()),
      ]);

  Widget mobileContent() {
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
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("😒"),
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
    var color = matchIndex % 2 != 0 ? Colors.grey[900] : null;
    var isThemeDark = isDarkMode(context);
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
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                    "${snapshot.data![index]['matches'][matchIndex]['match_awayteam_name']}"),
              ),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notification_add))
          ]),
        ),
      ),
    );
  }
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

bool isMobileSize(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 1000) {
    return true;
  }
  return false;
}

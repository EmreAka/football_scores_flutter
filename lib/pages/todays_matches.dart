import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:football_scores/widgets/navigation_drawer.dart' as NavigationDrawer;

class TodaysMatches extends StatelessWidget {
  TodaysMatches({super.key});

  final pb = PocketBase('https://gofootball.emreaka.tech/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer.NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Today's Matches"),
        backgroundColor: Colors.black87,
        
      ),
      body: Matches(pb: pb),
    );
    
  }
}

class Matches extends StatefulWidget {
  final PocketBase pb;

  const Matches({super.key, required this.pb});

  @override
  State<StatefulWidget> createState() => _MatchesState(pb);
}

class _MatchesState extends State {
  final PocketBase pb;
  late Future<dynamic> result;

  _MatchesState(this.pb);

  @override
  void initState() {
    super.initState();
    result = pb.send("/todaysmatches");
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors.black87,
                        child: ListTile(
                          title: Text(
                            snapshot.data[index]['country_name_en'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: snapshot.data[index]['matches'].length,
                        itemBuilder: (BuildContext context, int indexx) {
                          return Container(
                            color:
                                indexx % 2 == 0 ? Colors.white : Colors.black12,
                            child: ListTile(
                              title: Text(
                                snapshot.data[index]['matches'][indexx]
                                        ['home_team'] +
                                    " - " +
                                    snapshot.data[index]['matches'][indexx]
                                        ['away_team'],
                              ),
                              trailing: IconButton(icon: Icon(Icons.notification_add),onPressed: (){}),
                              subtitle: snapshot.data[index]['matches'][indexx]
                              ['match_live'] != "1" ? Text("Starts at: ${snapshot.data[index]['matches'][indexx]
                              ['match_time']}") : Text("Live: ${snapshot.data[index]['matches'][indexx]
                              ['match_status']}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  );
                });
          } else {
            return Text("Data is fetching...");
          }
        },
      );
}

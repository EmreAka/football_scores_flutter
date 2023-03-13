import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TodaysMatches extends StatelessWidget {
  const TodaysMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Matches"),
        backgroundColor: Colors.black87,
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
  final pb = PocketBase('https://api.emreaka.tech/');
  late Future<dynamic> result;

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
                              trailing: Text(snapshot.data[index]['matches']
                                  [indexx]['match_time']),
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
            return const Text("Data is fetching...");
          }
        },
      );
}

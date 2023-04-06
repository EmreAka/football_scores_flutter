import 'package:flutter/material.dart';
import 'package:football_scores/models/selected_route.dart';
import 'package:football_scores/pages/live_scores.dart';

import '../main.dart';
import '../pages/todays_matches.dart';

class NavigationDrawer extends StatelessWidget {
  SelectedRoute selectedRoute = SelectedRoute.home;
  NavigationDrawer({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  buildHeader(BuildContext context) => Container(
        color: Colors.black87,
        padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/77541730?v=4"),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Emre Aka",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            Text(
              "GitHub.com/emreaka",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      );

  buildMenuItems(BuildContext context) => Wrap(
        runSpacing: 10,
        children: [
          buildListTile(context, const Icon(Icons.home), "Home",
              SelectedRoute.home, const MyHomePage()),
          buildListTile(context, const Icon(Icons.sports_soccer),
              "Today's Matches", SelectedRoute.todaysMatches, TodaysMatches()),
          buildListTile(context, const Icon(Icons.forum), "Community",
              SelectedRoute.community, TodaysMatches()),
          buildListTile(context, const Icon(Icons.scoreboard), "Live Scores",
              SelectedRoute.liveScores, const LiveScores()),
          buildListTile(context, const Icon(Icons.score), "Standings",
              SelectedRoute.standings, const LiveScores()),
          buildListTile(context, const Icon(Icons.personal_injury), "Suspended and Injured Players",
              SelectedRoute.suspendedAndInjuredPlayers, const LiveScores()),
          const Divider(color: Colors.black12),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {},
            selected: selectedRoute == SelectedRoute.login ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Register"),
            onTap: () {},
            selected: selectedRoute == SelectedRoute.register ? true : false,
          ),
        ],
      );

  ListTile buildListTile(BuildContext context, Icon icon, String title,
      SelectedRoute route, Widget page) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        // Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      selected: selectedRoute == route ? true : false,
      selectedTileColor: const Color.fromARGB(255, 207, 233, 255),
      selectedColor: const Color.fromARGB(255, 14, 110, 236),
    );
  }
}

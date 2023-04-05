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
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/77541730?v=4"),
            ),
            SizedBox(height: 12,),
            Text("Emre Aka", style: TextStyle(fontSize: 28, color: Colors.white),),
            Text("GitHub.com/emreaka", style: TextStyle(fontSize: 16, color: Colors.white),),
          ],
        ),
      );

  buildMenuItems(BuildContext context) => Wrap(
        runSpacing: 10,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MyHomePage())),
            selected: selectedRoute == SelectedRoute.home ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text("Today's Matches"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TodaysMatches()));
            },
            selected: selectedRoute == SelectedRoute.todaysMatches ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text("Community"),
            onTap: () {},
            selected: selectedRoute == SelectedRoute.community ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.scoreboard),
            title: const Text("Live Scores"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveScores()));
            },
            selected: selectedRoute == SelectedRoute.liveScores ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.score),
            title: const Text("Standings"),
            onTap: () {},
            selected: selectedRoute == SelectedRoute.standings ? true : false,
          ),
          ListTile(
            leading: const Icon(Icons.personal_injury),
            title: const Text("Suspended and Injured Players"),
            onTap: () {},
            selected: selectedRoute == SelectedRoute.suspendedAndInjuredPlayers ? true : false,
          ),
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
}

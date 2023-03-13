import 'package:flutter/material.dart';
import 'package:football_scores/pages/todays_matches.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.black87,
      ),
      drawer: const NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

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
            Text("Aka.Emre@hotmail.com", style: TextStyle(fontSize: 16, color: Colors.white),),
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
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text("Today's Matches"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TodaysMatches()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text("Community"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.scoreboard),
            title: const Text("Live Scores"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.score),
            title: const Text("Standings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.personal_injury),
            title: const Text("Suspended and Injured Players"),
            onTap: () {},
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Register"),
            onTap: () {},
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:football_scores/widgets/navigation_drawer.dart' as NavigationDrawer;

class LiveScores extends StatelessWidget {
  const LiveScores({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Live Scores"),
    ),
    drawer: const NavigationDrawer.NavigationDrawer(),
  );
}
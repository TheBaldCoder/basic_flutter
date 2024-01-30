import 'dart:convert';

import 'package:basic_flutter/model/team.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  Future getTeams() async {
    var response = await http.get(Uri.http('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachtTeam in jsonData['data']) {
      final team = Team(
          abbreviation: eachtTeam['abbreviation'], city: eachtTeam['city']);

      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            // Is it done loading? Then show team data.
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                    );
                  });
            }
            // Still loading, show Loading Circle
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gordao.GG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _profileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _profileName,
              decoration: InputDecoration(
                hintText: 'GameName#BR1',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(profile: _profileName.text),
                  ),
                );
              },
              child: Text('GG'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String profile;

  DetailScreen({required this.profile});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String puuid = "";
  String gameName = "";
  String tagLine = "";

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final splitedInfo = widget.profile.split('#');
      gameName = splitedInfo[0];
      tagLine = splitedInfo[1];

      final response = await http.get(
        Uri.parse(
            "https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$gameName/$tagLine"),
        headers: {
          'Content-Type': 'application/json',
          'X-Riot-Token': 'RGAPI-d1c486f4-184f-4859-9715-60186e845b3c'
        },
      );
      final responseData = json.decode(response.body);

      setState(() {
        if (response.statusCode == 200 && responseData) {
          puuid = responseData.puuid;
        }
      });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Dados recebidos:'),
            Text(
              widget.profile,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              puuid,
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

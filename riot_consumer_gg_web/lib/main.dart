import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Image profileImage = Image.network('');
  List<Image> championsImages = List<Image>.empty(growable: true);
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

      final riotResponse = await http.get(
        Uri.parse(
            "https://localhost:7155/api/v1/lol/getInformations?gameName=$gameName&gameTag=$tagLine"),
        headers: {
          'Content-Type': 'application/json',
          'X-Riot-Token': 'RGAPI-d1c486f4-184f-4859-9715-60186e845b3c'
        },
      );
      final responseData = json.decode(riotResponse.body);

      setState(() {
        if (riotResponse.statusCode == 200 && responseData != null) {
          puuid = responseData['account']['puuid'];
          profileImage = Image.network(
              'https://ddragon.leagueoflegends.com/cdn/14.9.1/img/profileicon/${responseData['summoner']['profileIconId']}.png');

          for (var maestry in responseData['topMaesterys']) {
            championsImages.add(Image.network(
                'https://ddragon.leagueoflegends.com/cdn/14.9.1/img/champion/${maestry['championName']}.png'));
          }
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
            profileImage,
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: championsImages.length,
                itemBuilder: (context, index) {
                  return championsImages[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.black, // Define o fundo preto para a aplicação
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors
              .black, // Define a cor do AppBar para combinar com o fundo preto
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              color: Colors.white), // Define a cor dos textos para branco
          bodyText2: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Define a cor dos ícones para branco
      ),
      home:  MyHomePage(),
    );
  }
}



class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final TextEditingController _profileName = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Define o fundo preto para o Container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24.0,
            ), // Adiciona um espaço de 24 pixels acima do texto "Gordão.GG"
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 0.2), // Reduz o padding vertical
              child: Text(
                'GORDÃO.GG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0), // Define a margem lateral
              child: Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ), // Adiciona um espaço de 24 pixels abaixo do Divider
            Center(
              child: LogoContainer(), // Usa um widget não constante
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _profileName,
                      decoration: const InputDecoration(
                        hintText: 'Nick name + #TAG',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
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
                    child: const Text('GG'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230, // Define a largura do container
      height: 230, // Define a altura do container
      decoration: const BoxDecoration(
        shape: BoxShape.circle, // Define a forma como círculo
        color: Colors.white, // Define a cor do container como branca
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.5), // Move a imagem para baixo
          child: Image.network(
            'https://img.freepik.com/vetores-gratis/homem-com-excesso-de-peso-sentado-isolado_1308-133748.jpg?size=626&ext=jpg&ga=GA1.1.2082370165.1716422400&semt=ais_user',
            width: 150, // Define a largura da imagem
            height: 150, // Define a altura da imagem
            fit: BoxFit
                .cover, // Define como a imagem deve se ajustar ao contêiner
          ),
        ),
      ),
    );
  }
}

// SEGUNDA TELA

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
  int summonerLevel = 0;
  String rankedFlexTier = "";
  String rankedFlexRank = "";
  String rankedSoloTier = "";
  String rankedSoloRank = "";

  int championPoints1 = 0;
  int championPoints2 = 0;
  int championPoints3 = 0;

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
          summonerLevel = responseData['summoner']['summonerLevel'];

          for (var league in responseData['leagues']) {
            if (league['queueType'] == 'RANKED_FLEX_SR') {
              rankedFlexTier = league['tier'];
              rankedFlexRank = league['rank'];
            } else if (league['queueType'] == 'RANKED_SOLO_5x5') {
              rankedSoloTier = league['tier'];
              rankedSoloRank = league['rank'];
            }
          }

          List<int> championPointsList = [];
          for (var maestry in responseData['topMaesterys']) {
            championsImages.add(Image.network(
                'https://ddragon.leagueoflegends.com/cdn/14.9.1/img/champion/${maestry['championName']}.png'));
            championPointsList.add(maestry['championPoints']);
          }

          championPointsList.sort((a, b) => b.compareTo(a));

          if (championPointsList.length > 0) championPoints1 = championPointsList[0];
          if (championPointsList.length > 1) championPoints2 = championPointsList[1];
          if (championPointsList.length > 2) championPoints3 = championPointsList[2];
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
      titleTextStyle: const TextStyle(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0), // Margem em volta dos campo de texto e imagem
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dados recebidos:'),
                  Text(
                    widget.profile,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200, // Ajuste a altura conforme necessário
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: profileImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10), // Espaço entre a imagem e os campos de texto
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 100, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250, // Ajuste a largura conforme necessário
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Nick: ' + gameName,
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250, // Ajuste a largura conforme necessário
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Nível: ' + summonerLevel.toString(),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: SizedBox(
                    width: 270, // Ajuste a largura conforme necessário
                    child: TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Divisão SOLOQ: ' + rankedSoloTier + ' ' + rankedSoloRank,
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                  child: SizedBox(
                    width: 270, // Ajuste a largura conforme necessário
                    child: TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Divisão Flex: ' + rankedFlexTier + ' ' + rankedFlexRank,
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32), // Espaço entre os campos e o novo conteúdo
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Text(
              "Top Champions",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 16), // Espaço entre o divider e os novos campos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 50,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '  1  ',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '  2  ',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '  3  ',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Espaço entre os campos de texto e os quadros de imagem
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: championPoints1.toString(),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: championPoints2.toString(),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: championPoints3.toString(),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Espaço entre os campos de texto e os quadros de imagem
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: championsImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: championsImages[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
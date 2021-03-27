import 'dart:ui';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/pages/about.dart';
import 'package:booktrackerv2/pages/changelog.dart';
import 'package:booktrackerv2/pages/configs.dart';
import 'package:booktrackerv2/ui/addLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/versaoNomeChangelog.dart';
import '../ui/cardLivro.dart';
import 'package:booktrackerv2/db/livroDao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  bool exibirLidos = false;
  bool verParaLer = true;
  Icon iconSetaParaLer = Icon(Icons.keyboard_arrow_up_outlined);
  Icon iconSetaLidos = Icon(Icons.keyboard_arrow_down_outlined);
  bool animacao = true;
  bool animacaoParaLer = false;

  List<Map<String, dynamic>> livrosParaLer = [];
  List<Map<String, dynamic>> livrosLidos = [];
  final dbLivro = LivroDao.instance;

  @override
  void initState() {
    getExibirLidos();
    getAllLivros();
    getTema();
    super.initState();
  }

  Future<void> getExibirLidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    setState(() {
      exibirLidos = prefs.getBool('valorExibirLidos');
      if(exibirLidos){
        animacao = false;
        iconSetaLidos = exibirLidos
            ? Icon(Icons.keyboard_arrow_up_outlined)
            : Icon(Icons.keyboard_arrow_down_outlined);
      }
    });
  }


  bool tema; // 1 = dark
  Future<void> getTema() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tema = prefs.getBool('valorTema');
    if(tema == null){
      tema = true;
    }
  }

  Future<void> getAllLivros() async {
    var respostaParaLer = await dbLivro.queryAllLivrosParaLer();
    var respostaLidos = await dbLivro.queryAllLivrosLidos();
    setState(() {
      livrosParaLer = respostaParaLer;
      livrosLidos = respostaLidos;
    });
  }

  Future<void> getAllLivrosLidos() async {
    var respostaLidos = await dbLivro.queryAllLivrosLidos();
    setState(() {
      livrosLidos = respostaLidos;
    });
  }

  Future<void> getAllLivrosParaLer() async {
    var respostaParaLer = await dbLivro.queryAllLivrosParaLer();
    setState(() {
      livrosParaLer = respostaParaLer;
    });
  }

  refreshLidos() {
    setState(() {
      getTema();
    });
    getAllLivrosLidos();
  }

  refreshParaLer() {
    setState(() {
      getTema();
    });
    getAllLivrosParaLer();
  }

  refresh() {
    setState(() {
      getTema();
    });
    getAllLivros();
  }

  refreshTema() {
    setState(() {
      getTema();
    });
  }


  //BOTTOM MENU
  void bottomMenu(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                //TOPO

                Card(
                  margin: EdgeInsets.fromLTRB(50, 15, 50, 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[700], width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      versaoNomeChangelog.nomeApp +
                          " " +
                          versaoNomeChangelog.versaoApp,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.settings_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(
                    "Configurações",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              Configs(refreshTema: refreshTema),
                          fullscreenDialog: true,
                        ));
                  },
                ),
                Divider(
                  thickness: 1,
                ),

                ListTile(
                  leading: Icon(Icons.text_snippet_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(
                    "Changelog",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Changelog(),
                          fullscreenDialog: true,
                        ));
                  },
                ),
                Divider(
                  thickness: 1,
                ),

                ListTile(
                  leading: Icon(Icons.text_snippet_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(
                    "Sobre",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => About(),
                          fullscreenDialog: true,
                        ));
                  },
                ),
                SizedBox(height: 65)
              ],
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    animacaoParaLer = !animacaoParaLer;
                    verParaLer = verParaLer ? false : true;
                    iconSetaParaLer = verParaLer
                        ? Icon(Icons.keyboard_arrow_up_outlined)
                        : Icon(Icons.keyboard_arrow_down_outlined);
                    refreshParaLer();
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 0, 2, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lendo", //.toUpperCase()
                          textAlign: TextAlign.start,
                          style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              livrosParaLer.length.toString(),
                              style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),

                            IconButton(
                              icon: iconSetaParaLer,iconSize: 26,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 450),
            child: animacaoParaLer
                ? SizedBox.shrink()
                : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: 8,
                  ),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              itemCount: livrosParaLer.length,
              itemBuilder: (context, int index) {
                return CardLivro(
                  key: UniqueKey(),
                  livro: new Livro(
                    id: livrosParaLer[index]['idLivro'],
                    nome: livrosParaLer[index]['nome'],
                    numPaginas: livrosParaLer[index]['numPaginas'],
                    autor: livrosParaLer[index]['autor'],
                    lido: livrosParaLer[index]['lido'],
                    capa: livrosParaLer[index]['capa'],
                  ),
                  tema: tema,
                  refreshLista: refresh,
                );
              },
            ),
          ),

          const SizedBox(height: 15,),

          InkWell(
            onTap: () {
              animacao = !animacao;
              exibirLidos = exibirLidos ? false : true;
              iconSetaLidos = exibirLidos
                  ? Icon(Icons.keyboard_arrow_up_outlined)
                  : Icon(Icons.keyboard_arrow_down_outlined);

              getAllLivrosLidos();
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 2, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Terminados",
                    textAlign: TextAlign.start,
                    style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        livrosLidos.length.toString(),
                        style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(icon: iconSetaLidos, iconSize: 26,),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 450),
            child: animacao
                ? SizedBox.shrink()
                : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(
                    height: 8,
                  ),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              itemCount: livrosLidos.length,
              itemBuilder: (context, int index) {
                return CardLivro(
                  key: UniqueKey(),
                  livro: new Livro(
                    id: livrosLidos[index]['idLivro'],
                    nome: livrosLidos[index]['nome'],
                    numPaginas: livrosLidos[index]['numPaginas'],
                    autor: livrosLidos[index]['autor'],
                    lido: livrosLidos[index]['lido'],
                    capa: livrosLidos[index]['capa'],
                  ),
                  tema: tema,
                  refreshLista: refresh,
                );
              },
            ),
          ),

          const SizedBox(
            height: 40,
          )
        ]),

        //BOTTOMBAR
        floatingActionButton: Container(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
            elevation: 0.0,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddLivro(refreshLista: refresh,tema: tema,),
                    fullscreenDialog: true,
                  )
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: Container(
              child: Row(
                  children: <Widget>[
                    IconButton(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        icon: Icon(
                          Icons.menu,
                          size: 25,
                        ),
                        onPressed: () {
                          bottomMenu(context);
                        }),
                  ])),
        ));
  }
}


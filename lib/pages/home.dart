import 'dart:ui';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/class/pages.dart';
import 'package:booktrackerv2/pages/configs.dart';
import 'package:booktrackerv2/ui/addLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/cardLivro.dart';
import 'package:booktrackerv2/db/livroDao.dart';
import '../util/versaoNomeChangelog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  List<Pages> listPages = new Pages().getListPages();
  bool animacaoLista = true;
  bool animacaoNomePagina = true;
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  int paginaAtual;

  @override
  void initState() {
    paginaAtual = listPages[1].id;
    getAllLivros();
    getTema();
    super.initState();
  }

  Future<void> getAllLivros() async {
    var resp = await dbLivro.queryAllLivros(paginaAtual);
    setState(() {
      animacaoNomePagina = false;
      animacaoLista = false;
      listaLivros = resp;
    });
  }

  refresh() {
    setState(() {
      animacaoLista = true;
      getTema();
    });
    Future.delayed(Duration(milliseconds: 300), () {
      getAllLivros();
    });
  }

  bool tema; // 1 = dark
  Future<void> getTema() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tema = prefs.getBool('valorTema');
    if (tema == null) {
      tema = true;
    }
  }

  refreshTema() {
    setState(() {
      getTema();
    });
  }

  //BOTTOM MENU
  void openBottomMenuPages(context) {
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.fromLTRB(50, 15, 50, 20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[700], width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        versaoNomeChangelog.nomeApp +
                            " " +
                            versaoNomeChangelog.versaoApp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.book,
                        color: paginaAtual == 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.headline6.color),
                    trailing: Visibility(
                        visible: paginaAtual != 1,
                        child: Icon(Icons.keyboard_arrow_right)),
                    title: Text(
                      "Lendo",
                      style: TextStyle(
                          fontSize: 18,
                          color: paginaAtual == 1
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (paginaAtual != 1) {
                        setState(() {
                          animacaoNomePagina = true;
                          animacaoLista = true;
                        });
                        paginaAtual = 1;
                        Future.delayed(Duration(milliseconds: 300), () {
                          getAllLivros();
                        });
                      }
                    },
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.book,
                        color: paginaAtual == 0
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.headline6.color),
                    trailing: Visibility(
                        visible: paginaAtual != 0,
                        child: Icon(Icons.keyboard_arrow_right)),
                    title: Text(
                      "Para Ler",
                      style: TextStyle(
                          fontSize: 18,
                          color: paginaAtual == 0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      if (paginaAtual != 0) {
                        setState(() {
                          animacaoNomePagina = true;
                          animacaoLista = true;
                        });
                        paginaAtual = 0;
                        Future.delayed(Duration(milliseconds: 300), () {
                          getAllLivros();
                        });
                      }
                    },
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.book,
                        color: paginaAtual == 2
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.headline6.color),
                    trailing: Visibility(
                        visible: paginaAtual != 2,
                        child: Icon(Icons.keyboard_arrow_right)),
                    title: Text(
                      "Lidos",
                      style: TextStyle(
                          fontSize: 18,
                          color: paginaAtual == 2
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (paginaAtual != 2) {
                        setState(() {
                          animacaoNomePagina = true;
                          animacaoLista = true;
                        });
                        paginaAtual = 2;
                        Future.delayed(Duration(milliseconds: 300), () {
                          getAllLivros();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: animacaoNomePagina
              ? SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        listPages[paginaAtual].nome, //.toUpperCase()
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        listaLivros.length.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: animacaoLista
              ? SizedBox.shrink()
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 8,
                  ),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  itemCount: listaLivros.length,
                  itemBuilder: (context, int index) {
                    return CardLivro(
                      key: UniqueKey(),
                      livro: new Livro(
                        id: listaLivros[index]['idLivro'],
                        nome: listaLivros[index]['nome'],
                        numPaginas: listaLivros[index]['numPaginas'],
                        autor: listaLivros[index]['autor'],
                        lido: listaLivros[index]['estado'],
                        capa: listaLivros[index]['capa'],
                      ),
                      tema: tema,
                      refreshLista: refresh,
                      paginaAtual: paginaAtual,
                    );
                  },
                ),
        ),
        const SizedBox(
          height: 50,
        )
      ]),

      //BOTTOMBAR
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  size: 25,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddLivro(
                            refreshLista: refresh,
                            tema: tema,
                            paginaAtual: paginaAtual),
                        fullscreenDialog: true,
                      ));
                }),
            IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 25,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  openBottomMenuPages(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 24,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Configs(),
                        fullscreenDialog: true,
                      ));
                }),
          ],
        ),
      )),
    );
  }
}

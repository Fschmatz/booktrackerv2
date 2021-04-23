import 'dart:ui';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/class/pages.dart';
import 'package:booktrackerv2/pages/configs.dart';
import 'package:booktrackerv2/ui/addLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../ui/cardLivro.dart';
import 'package:booktrackerv2/db/livroDao.dart';
import '../util/versaoNomeChangelog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Pages> listPages = new Pages().getListPages();
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  int paginaAtual;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    paginaAtual = listPages[1].id;
    getAllLivros();
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getAllLivros() async {
    var resp = await dbLivro.queryAllLivros(paginaAtual);
    setState(() {
      listaLivros = resp;
    });
  }

  Future<void> refresh() {
    _controller.reset();
    getAllLivros();
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
                    color:
                        Theme.of(context).bottomSheetTheme.modalBackgroundColor,
                    margin: EdgeInsets.fromLTRB(50, 15, 50, 20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[700], width: 1),
                      borderRadius: BorderRadius.circular(15),
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
                            : Theme.of(context).hintColor),
                    trailing: Visibility(
                        visible: paginaAtual != 1,
                        child: Icon(Icons.keyboard_arrow_right,
                            color: Theme.of(context).hintColor)),
                    title: Text(
                      "Lendo",
                      style: TextStyle(
                          fontSize: 17,
                          color: paginaAtual == 1
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (paginaAtual != 1) {
                        _controller.reset();
                        paginaAtual = 1;
                        getAllLivros();
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
                            : Theme.of(context).hintColor),
                    trailing: Visibility(
                        visible: paginaAtual != 0,
                        child: Icon(Icons.keyboard_arrow_right,
                            color: Theme.of(context).hintColor)),
                    title: Text(
                      "Para Ler",
                      style: TextStyle(
                          fontSize: 17,
                          color: paginaAtual == 0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      if (paginaAtual != 0) {
                        _controller.reset();
                        paginaAtual = 0;
                        getAllLivros();
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
                            : Theme.of(context).hintColor),
                    trailing: Visibility(
                      visible: paginaAtual != 2,
                      child: Icon(Icons.keyboard_arrow_right,
                          color: Theme.of(context).hintColor),
                    ),
                    title: Text(
                      "Lidos",
                      style: TextStyle(
                          fontSize: 17,
                          color: paginaAtual == 2
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.headline6.color),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (paginaAtual != 2) {
                        _controller.reset();
                        paginaAtual = 2;
                        getAllLivros();
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
    _controller.forward();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              listPages[paginaAtual].nome, //.toUpperCase()
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              listaLivros.length.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(children: <Widget>[
        FadeTransition(
          opacity: _animation,
          child: ListView.separated(
            key: UniqueKey(),
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
                refreshLista: refresh,
                paginaAtual: paginaAtual,
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
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
                splashRadius: 30,
                icon: Icon(
                  Icons.add,
                  size: 26,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddLivro(
                            refreshLista: refresh, paginaAtual: paginaAtual),
                        fullscreenDialog: true,
                      ));
                }),
            IconButton(
                splashRadius: 30,
                icon: Icon(
                  Icons.menu,
                  size: 25,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  openBottomMenuPages(context);
                }),
            IconButton(
                splashRadius: 30,
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

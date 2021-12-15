import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/pg_novo_livro.dart';
import 'package:booktrackerv2/ui/card_livro.dart';
import 'package:flutter/material.dart';

import 'configs/pg_configs.dart';

class PgBookList extends StatefulWidget {
  int bookState;

  PgBookList({Key? key, required this.bookState}) : super(key: key);

  @override
  _PgBookListState createState() => _PgBookListState();
}

class _PgBookListState extends State<PgBookList> {
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  bool loading = true;

  @override
  void initState() {
    getLivrosState();
    super.initState();
  }

  void getLivrosState() async {
    var resp = await dbLivro.queryAllLivrosEstado(widget.bookState);
    setState(() {
      loading = false;
      listaLivros = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookTracker',
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context)
                    .textTheme
                    .headline6!
                    .color!
                    .withOpacity(0.8),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PgConfigs(),
                      fullscreenDialog: true,
                    )).then((value) => {
                      if (widget.bookState == 2) {getLivrosState()}
                    });
              }),
        ],
      ),
      body: loading
          ? const Center(child: SizedBox.shrink())
          : ListView(
              children: [
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 4,
                  ),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listaLivros.length,
                  itemBuilder: (context, int index) {
                    return CardLivro(
                      key: UniqueKey(),
                      livro: Livro(
                        id: listaLivros[index]['idLivro'],
                        nome: listaLivros[index]['nome'],
                        numPaginas: listaLivros[index]['numPaginas'],
                        autor: listaLivros[index]['autor'],
                        lido: listaLivros[index]['estado'],
                        capa: listaLivros[index]['capa'],
                      ),
                      getLivrosState: getLivrosState,
                      paginaAtual: widget.bookState,
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        heroTag: "btn1",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    PgNovoLivro(paginaAtual: widget.bookState),
                fullscreenDialog: true,
              )).then((value) => getLivrosState());
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

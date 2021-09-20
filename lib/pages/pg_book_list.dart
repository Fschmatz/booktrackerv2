import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/pg_novo_livro.dart';
import 'package:booktrackerv2/ui/card_livro.dart';
import 'package:flutter/material.dart';

class PgBookList extends StatefulWidget {
  int bookState;

  PgBookList({Key? key, required this.bookState}) : super(key: key);

  @override
  _PgBookListState createState() => _PgBookListState();
}

class _PgBookListState extends State<PgBookList> {
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;

  @override
  void initState() {
    getAllLivros();
    super.initState();
  }

  Future<void> getAllLivros() async {
    var resp = await dbLivro.queryAllLivrosEstado(widget.bookState);
    setState(() {
      listaLivros = resp;
    });
  }

  void refresh() {
    getAllLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                refreshLista: refresh,
                paginaAtual: 1,
              );
            },
          ),
          const SizedBox(
            height: 75,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
        elevation: 1,
        heroTag: "btn1",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    PgNovoLivro(paginaAtual: widget.bookState),
                fullscreenDialog: true,
              )).then((value) => refresh());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

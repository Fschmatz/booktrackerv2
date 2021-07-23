import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livroDao.dart';
import 'package:booktrackerv2/pages/pgNovoLivro.dart';
import 'package:booktrackerv2/ui/cardLivro.dart';
import 'package:flutter/material.dart';

class PgLendo extends StatefulWidget {
  const PgLendo({Key? key}) : super(key: key);

  @override
  _PgLendoState createState() => _PgLendoState();
}

class _PgLendoState extends State<PgLendo> {
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  bool loading = true;

  @override
  void initState() {
    getAllLivros();
    super.initState();
  }

  Future<void> getAllLivros() async {
    var resp = await dbLivro.queryAllLivros(1);
    setState(() {
      listaLivros = resp;
      loading = false;
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
            separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 4,
            ),
            physics: ScrollPhysics(),
            shrinkWrap: true,
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
                paginaAtual: 1,
              );
            },
          ),
          const SizedBox(
            height: 50,
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
                    PgNovoLivro(
                        paginaAtual: 1
                    ),
                fullscreenDialog: true,
              )).then((value) => refresh());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

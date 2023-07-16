import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/ui/card_livro.dart';
import 'package:flutter/material.dart';

class BookList extends StatefulWidget {
  int bookState;

  BookList({Key? key, required this.bookState}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
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
    listaLivros = resp;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)
          ? const Center(child: SizedBox.shrink())
          : (listaLivros.isEmpty)
              ? const Center(
                  child: Text(
                  'Está um pouco vazio por aqui!',
                  style: TextStyle(fontSize: 16),
                ))
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
                            lido: listaLivros[index]['lido'],
                            capa: listaLivros[index]['capa'],
                          ),
                          getLivrosState: getLivrosState,
                          paginaAtual: widget.bookState,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
    );
  }
}

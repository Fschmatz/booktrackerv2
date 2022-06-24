import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/novo_livro.dart';
import 'package:booktrackerv2/ui/card_livro.dart';
import 'package:flutter/material.dart';
import 'configs/configs.dart';

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
    getLivrosState(false);
    super.initState();
  }

  void getLivrosState([bool refresh = true]) async {
    if (refresh) {
      setState(() {
        loading = true;
      });
    }
    var resp = await dbLivro.queryAllLivrosEstado(widget.bookState);
    setState(() {
      loading = false;
      listaLivros = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('BookTracker'),
              pinned: false,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                    tooltip: "Adicionar Livro",
                    icon: const Icon(
                      Icons.add_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NovoLivro(paginaAtual: widget.bookState),
                          )).then((value) => getLivrosState());
                    }),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                    tooltip: "Configurações",
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Configs(
                              refresh: getLivrosState,
                            ),
                          ));
                    }),
              ],
            ),
          ];
        },
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
                    height: 50,
                  )
                ],
              ),
      ),
    );
  }
}

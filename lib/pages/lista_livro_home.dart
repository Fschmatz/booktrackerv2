import 'package:async_redux/async_redux.dart';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/card_livro.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';

class ListaLivroHome extends StatefulWidget {
  final SituacaoLivro situacaoLivro;

  ListaLivroHome({Key? key, required this.situacaoLivro}) : super(key: key);

  @override
  State<ListaLivroHome> createState() => _ListaLivroHomeState();
}

class _ListaLivroHomeState extends State<ListaLivroHome> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Livro>>(converter: (store) {
      return selectListLivroByPaginaAtual(widget.situacaoLivro);
    }, builder: (context, livros) {
      return ListView(
        children: [
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 8,
            ),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: livros.length,
            itemBuilder: (context, int index) {
              Livro livro = livros[index];

              return CardLivro(
                key: ValueKey(livro.id),
                livro: livro,
              );
            },
          ),
          const SizedBox(
            height: 50,
          )
        ],
      );
    });
  }
}

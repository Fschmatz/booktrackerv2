import 'package:async_redux/async_redux.dart';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/card_livro.dart';
import 'package:flutter/material.dart';

import '../redux/app_state.dart';
import '../redux/selectors.dart';

class ListaLivroHome extends StatefulWidget {
  ListaLivroHome({Key? key}) : super(key: key);

  @override
  State<ListaLivroHome> createState() => _ListaLivroHomeState();
}

class _ListaLivroHomeState extends State<ListaLivroHome> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Livro>>(converter: (store) {
      return selectListLivroByPaginaAtual();
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
              return CardLivro(
                key: UniqueKey(),
                livro: livros[index],
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

import 'package:flutter/material.dart';

import '../class/livro.dart';
import 'capa_livro.dart';
import 'modal_opcoes_livro.dart';

class CardLivroList extends StatelessWidget {
  final Livro livro;

  CardLivroList({Key? key, required this.livro}) : super(key: key);

  final BorderRadius _capaBorder = const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12));
  final BorderRadius _cardBorder = BorderRadius.circular(12);
  final double _capaHeight = 135;
  final double _capaWidth = 95;
  final TextStyle _styleNome = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  final TextStyle _styleAutorPaginas = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      margin: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: _cardBorder,
        onTap: () => ModalOpcoesLivro.show(context, livro, isGrid: false),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: CapaLivro(
                  capa: livro.capa,
                  borderRadius: _capaBorder,
                  width: _capaWidth,
                  height: _capaHeight,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.nome,
                      style: _styleNome,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Visibility(
                      visible: livro.autor != null && livro.autor!.isNotEmpty,
                      child: Text(
                        livro.autor ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _styleAutorPaginas.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Visibility(
                      visible: livro.numPaginas != null && livro.numPaginas != 0,
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "${livro.numPaginas} Páginas",
                        style: _styleAutorPaginas.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

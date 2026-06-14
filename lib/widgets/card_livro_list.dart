import 'package:flutter/material.dart';

import '../class/livro.dart';
import 'capa_livro.dart';
import 'modal_opcoes_livro.dart';

class CardLivroList extends StatelessWidget {
  final Livro livro;

  CardLivroList({Key? key, required this.livro}) : super(key: key);

  final BorderRadius _capaBorder = const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16));
  final BorderRadius _cardBorder = BorderRadius.circular(16);
  final double _capaHeight = 135;
  final double _capaWidth = 95;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainer,
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
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Visibility(
                      visible: livro.numPaginas != null && livro.numPaginas != 0,
                      child: Text(
                        "${livro.numPaginas} Páginas",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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

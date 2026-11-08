import 'package:booktrackerv2/util/app_constants.dart';
import 'package:flutter/material.dart';

import '../class/livro.dart';
import '../enum/situacao_livro.dart';
import '../util/utils_functions.dart';

class CardResumo extends StatelessWidget {
  final List<Livro> livros;
  final bool useGrid;
  final SituacaoLivro? situacaoLivro;

  const CardResumo({
    Key? key,
    required this.livros,
    required this.useGrid,
    this.situacaoLivro,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (livros.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int totalLivros = livros.length;
    final int totalPaginas = livros.fold<int>(0, (previousValue, element) => previousValue + (element.numPaginas ?? 0));

    final livrosComPaginas = livros.where((l) => (l.numPaginas ?? 0) > 0).toList();
    Livro? livroMenor;
    Livro? livroMaior;

    if (livrosComPaginas.isNotEmpty) {
      livroMenor = livrosComPaginas.reduce((curr, next) => (curr.numPaginas ?? 0) <= (next.numPaginas ?? 0) ? curr : next);

      livroMaior = livrosComPaginas.reduce((curr, next) => (curr.numPaginas ?? 0) >= (next.numPaginas ?? 0) ? curr : next);
    }

    final int mediaPaginas = totalLivros > 0 ? (totalPaginas / totalLivros).round() : 0;

    // Livro mais antigo adicionado
    Livro? livroMaisAntigo;
    final livrosComData = livros.where((l) => UtilsFunctions.parseData(l.criadoEm) != null).toList();
    if (livrosComData.isNotEmpty) {
      livroMaisAntigo = livrosComData.reduce((curr, next) {
        final d1 = UtilsFunctions.parseData(curr.criadoEm)!;
        final d2 = UtilsFunctions.parseData(next.criadoEm)!;
        return d1.isBefore(d2) ? curr : next;
      });
    }

    final bool isPaginaLidos = situacaoLivro == SituacaoLivro.LIDO;

    return Card(
      margin: EdgeInsets.fromLTRB(16, 0, 16, (useGrid ? 10 : 12)),
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.cardResumoBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "$totalLivros",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        height: 1,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      totalLivros == 1 ? "livro" : "livros",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "$totalPaginas",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            height: 1,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "páginas",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Média de $mediaPaginas por livro",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLivroRow(
                    context,
                    label: "Menor",
                    livro: livroMenor,
                  ),
                  const SizedBox(height: 8),
                  _buildLivroRow(
                    context,
                    label: "Maior",
                    livro: livroMaior,
                  ),
                  if (!isPaginaLidos && livroMaisAntigo != null) ...[
                    const SizedBox(height: 8),
                    _buildLivroRow(
                      context,
                      label: "Mais Antigo",
                      livro: livroMaisAntigo,
                      isMaisAntigo: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivroRow(
    BuildContext context, {
    required String label,
    required Livro? livro,
    bool isMaisAntigo = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int paginas = livro?.numPaginas ?? 0;
    final String timeAgo = isMaisAntigo && livro?.criadoEm != null ? UtilsFunctions.formatTimeAgo(livro!.criadoEm) : '';
    final bool showChip = isMaisAntigo ? timeAgo.isNotEmpty : (livro != null && paginas > 0);
    final IconData chipIcon = isMaisAntigo ? Icons.access_time_rounded : Icons.menu_book_outlined;
    final String chipText = isMaisAntigo ? timeAgo : "$paginas p.";

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            livro?.nome ?? "-",
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (showChip) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  chipIcon,
                  size: 11,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  chipText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

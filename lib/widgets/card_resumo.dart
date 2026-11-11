import 'package:flutter/material.dart';

import '../class/livro.dart';
import '../enum/situacao_livro.dart';
import '../redux/build_context_extension.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';
import '../util/utils_functions.dart';

class CardResumo extends StatefulWidget {
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
  State<CardResumo> createState() => _CardResumoState();
}

class _CardResumoState extends State<CardResumo> {
  bool? _isExpanded;

  @override
  Widget build(BuildContext context) {
    if (widget.livros.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool defaultExpand = context.select(
      (state) => selectParameterValueByKeyAsBoolean(
        state,
        AppConstants.expandResumePageCardAppParameter,
        defaultValue: false,
      ),
    );
    final bool isExpanded = _isExpanded ?? defaultExpand;
    final int totalLivros = widget.livros.length;
    final int totalPaginas = widget.livros.fold<int>(0, (previousValue, element) => previousValue + (element.numPaginas ?? 0));
    final livrosComPaginas = widget.livros.where((l) => (l.numPaginas ?? 0) > 0).toList();
    Livro? livroMenor;
    Livro? livroMaior;

    if (livrosComPaginas.isNotEmpty) {
      livroMenor = livrosComPaginas.reduce((curr, next) => (curr.numPaginas ?? 0) <= (next.numPaginas ?? 0) ? curr : next);
      livroMaior = livrosComPaginas.reduce((curr, next) => (curr.numPaginas ?? 0) >= (next.numPaginas ?? 0) ? curr : next);
    }

    final int mediaPaginas = totalLivros > 0 ? (totalPaginas / totalLivros).round() : 0;
    int medianaPaginas = 0;

    if (livrosComPaginas.isNotEmpty) {
      final sorted = [...livrosComPaginas]..sort((a, b) => (a.numPaginas ?? 0).compareTo(b.numPaginas ?? 0));
      final mid = sorted.length ~/ 2;
      medianaPaginas =
          sorted.length.isOdd ? (sorted[mid].numPaginas ?? 0) : (((sorted[mid - 1].numPaginas ?? 0) + (sorted[mid].numPaginas ?? 0)) / 2).round();
    }

    final bool isPaginaLendo = widget.situacaoLivro == SituacaoLivro.LENDO;
    final bool isPaginaLidos = widget.situacaoLivro == SituacaoLivro.LIDO;
    final bool isPaginaParaLer = widget.situacaoLivro == SituacaoLivro.PARA_LER;
    Livro? livroMaisAntigo;
    String? dataLivroMaisAntigo;

    if (isPaginaLendo) {
      final livrosComLendoEm = widget.livros.where((l) => UtilsFunctions.parseData(l.lendoEm) != null).toList();

      if (livrosComLendoEm.isNotEmpty) {
        livroMaisAntigo = livrosComLendoEm.reduce((curr, next) {
          final d1 = UtilsFunctions.parseData(curr.lendoEm)!;
          final d2 = UtilsFunctions.parseData(next.lendoEm)!;
          return d1.isBefore(d2) ? curr : next;
        });

        dataLivroMaisAntigo = livroMaisAntigo.lendoEm;
      }
    }

    if (livroMaisAntigo == null) {
      final livrosComCriadoEm = widget.livros.where((l) => UtilsFunctions.parseData(l.criadoEm) != null).toList();

      if (livrosComCriadoEm.isNotEmpty) {
        livroMaisAntigo = livrosComCriadoEm.reduce((curr, next) {
          final d1 = UtilsFunctions.parseData(curr.criadoEm)!;
          final d2 = UtilsFunctions.parseData(next.criadoEm)!;
          return d1.isBefore(d2) ? curr : next;
        });
        dataLivroMaisAntigo = livroMaisAntigo.criadoEm;
      }
    }

    Livro? ultimoAdicionado;

    if (isPaginaLendo || isPaginaParaLer) {
      final livrosComCriadoEm = widget.livros.where((l) => UtilsFunctions.parseData(l.criadoEm) != null).toList();

      if (livrosComCriadoEm.isNotEmpty) {
        ultimoAdicionado = livrosComCriadoEm.reduce((curr, next) {
          final d1 = UtilsFunctions.parseData(curr.criadoEm)!;
          final d2 = UtilsFunctions.parseData(next.criadoEm)!;
          return d1.isAfter(d2) ? curr : next;
        });
      }
    }

    final now = DateTime.now();
    final int adicionadosEsteMes = widget.livros.where((l) {
      final String? dateStr = isPaginaLidos
          ? l.finalizadoEm
          : isPaginaLendo
              ? l.lendoEm
              : l.criadoEm;
      final date = UtilsFunctions.parseData(dateStr);
      return date != null && date.year == now.year && date.month == now.month;
    }).length;

    Livro? ultimoLivroLido;

    if (isPaginaLidos) {
      final livrosFinalizadosComData = widget.livros.where((l) => UtilsFunctions.parseData(l.finalizadoEm) != null).toList();

      if (livrosFinalizadosComData.isNotEmpty) {
        ultimoLivroLido = livrosFinalizadosComData.reduce((curr, next) {
          final d1 = UtilsFunctions.parseData(curr.finalizadoEm)!;
          final d2 = UtilsFunctions.parseData(next.finalizadoEm)!;
          return d1.isAfter(d2) ? curr : next;
        });
      }
    }

    return Card(
      margin: EdgeInsets.fromLTRB(16, 0, 16, (widget.useGrid ? 10 : 12)),
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.cardResumoBorderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.cardResumoBorderRadius),
        onTap: () {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$totalLivros",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: totalLivros == 1 ? " livro · " : " livros · ",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: "$totalPaginas",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: " páginas",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),

              // Detalhes quando expandido
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Linha Média
                      _buildInfoRow(
                        context,
                        label: "Média",
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$mediaPaginas p.",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              " · mediana ",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "$medianaPaginas p.",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Linha Menor
                      _buildInfoRow(
                        context,
                        label: "Menor",
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                livroMenor?.nome ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (livroMenor != null && (livroMenor.numPaginas ?? 0) > 0)
                              Text(
                                " · ${livroMenor.numPaginas} p.",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Linha Maior
                      _buildInfoRow(
                        context,
                        label: "Maior",
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                livroMaior?.nome ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (livroMaior != null && (livroMaior.numPaginas ?? 0) > 0)
                              Text(
                                " · ${livroMaior.numPaginas} p.",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Linha Mais antigo (não exibe na página de lidos)
                      if (!isPaginaLidos && livroMaisAntigo != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          label: "Mais antigo",
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  livroMaisAntigo.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (UtilsFunctions.formatTimeAgo(dataLivroMaisAntigo).isNotEmpty)
                                Text(
                                  " · ${UtilsFunctions.formatTimeAgo(dataLivroMaisAntigo)}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],

                      // Linha Último lido (apenas na página de lidos)
                      if (isPaginaLidos && ultimoLivroLido != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          label: "Último lido",
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  ultimoLivroLido.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (UtilsFunctions.formatTimeAgo(ultimoLivroLido.finalizadoEm).isNotEmpty)
                                Text(
                                  " · ${UtilsFunctions.formatTimeAgo(ultimoLivroLido.finalizadoEm)}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],

                      // Linha Ult. adic. (apenas Lendo e Para Ler)
                      if ((isPaginaLendo || isPaginaParaLer) && ultimoAdicionado != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          label: "Ult. adic.",
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  ultimoAdicionado.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (UtilsFunctions.formatTimeAgo(ultimoAdicionado.criadoEm).isNotEmpty)
                                Text(
                                  " · ${UtilsFunctions.formatTimeAgo(ultimoAdicionado.criadoEm)}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],

                      ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          label: "Este mês",
                          content: Text(
                            "$adicionadosEsteMes ${adicionadosEsteMes == 1 ? 'livro' : 'livros'} adic.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: content,
          ),
        ),
      ],
    );
  }
}

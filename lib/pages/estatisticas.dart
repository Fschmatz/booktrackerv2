import 'package:booktrackerv2/class/livro_extension.dart';
import 'package:booktrackerv2/enum/situacao_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../redux/selectors.dart';

class Estatisticas extends StatefulWidget {
  const Estatisticas({Key? key}) : super(key: key);

  @override
  State<Estatisticas> createState() => _EstatisticasState();
}

class _EstatisticasState extends State<Estatisticas> {
  bool _loading = true;
  int? _livrosLendo = 0;
  int? _livrosParaLer = 0;
  int? _livrosLidos = 0;
  int? _paginasLendo = 0;
  int? _paginasParaLer = 0;
  int? _paginasLidos = 0;
  int? _quantidadeAutores = 0;

  @override
  void initState() {
    super.initState();

    loadDadosParaEstatisticas();
  }

  Future<void> loadDadosParaEstatisticas() async {
    await LivroService().loadAllLivrosParaEstatisticas();

    _livrosLendo = selectListLivroByPaginaAtual(store.state, SituacaoLivro.LENDO).quantidade;
    _livrosParaLer = selectListLivroByPaginaAtual(store.state, SituacaoLivro.PARA_LER).quantidade;
    _livrosLidos = selectListLivroByPaginaAtual(store.state, SituacaoLivro.LIDO).quantidade;
    _paginasLendo = selectListLivroByPaginaAtual(store.state, SituacaoLivro.LENDO).totalPaginas;
    _paginasParaLer = selectListLivroByPaginaAtual(store.state, SituacaoLivro.PARA_LER).totalPaginas;
    _paginasLidos = selectListLivroByPaginaAtual(store.state, SituacaoLivro.LIDO).totalPaginas;

    var respAutores = await LivroService().findContagemAutoresDistinct();
    _quantidadeAutores = respAutores ?? 0;

    setState(() {
      _loading = false;
    });
  }

  Widget _miniCard(String label, IconData icon, int value, Color bg, Color fg) {
    return Expanded(
      child: Card(
        color: bg,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: fg),
              const SizedBox(height: 12),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg.withValues(alpha: 0.75)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardEstatisticas(String tituloCard, int? valorLendo, int? valorParaLer, int? valorLidos, Color accent) {
    final cs = Theme.of(context).colorScheme;
    int soma = (valorLidos! + valorParaLer! + valorLendo!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(tituloCard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accent)),
          ),
          Row(
            children: [
              _miniCard('Lendo', Icons.book_outlined, valorLendo, cs.surfaceContainerHighest, cs.onSurface),
              const SizedBox(width: 8),
              _miniCard('Para Ler', Icons.bookmark_outline_outlined, valorParaLer, cs.surfaceContainerHighest, cs.onSurface),
              const SizedBox(width: 8),
              _miniCard('Lidos', Icons.task_outlined, valorLidos, cs.surfaceContainerHighest, cs.onSurface),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_list_bulleted_outlined, color: cs.onPrimaryContainer),
                      const SizedBox(width: 16),
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    soma.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardAutores(String tituloCard, int? valor, Color accent) {
    final cs = Theme.of(context).colorScheme;
    //DB CONTA O VALOR VAZIO, QUE ESTÁ CONFIGURADO PARA O LIVRO SEM AUTOR
    int valorCalculado = valor == 0 ? 0 : (valor! - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(tituloCard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accent)),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            color: cs.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline_outlined, color: cs.onSecondaryContainer),
                      const SizedBox(width: 16),
                      Text(
                        'Autores',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    valorCalculado.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: cs.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: _loading
          ? const Center(child: SizedBox.shrink())
          : ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              children: [
                cardEstatisticas('Livros', _livrosLendo, _livrosParaLer, _livrosLidos, accent),
                cardEstatisticas('Páginas', _paginasLendo, _paginasParaLer, _paginasLidos, accent),
                cardAutores('Geral', _quantidadeAutores, accent),
              ],
            ),
    );
  }
}

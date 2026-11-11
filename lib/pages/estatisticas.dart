import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

import '../class/estatisticas_livro.dart';
import '../widgets/estatistica_geral_card.dart';
import '../widgets/estatistica_livros_paginas_card.dart';

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
  int? _livrosAdicionadosAnoAtual = 0;
  int _mediaPaginas = 0;
  String? _menorLivroNome;
  String? _maiorLivroNome;

  @override
  void initState() {
    super.initState();

    loadDadosParaEstatisticas();
  }

  Future<void> loadDadosParaEstatisticas() async {
    final mapStats = await LivroService().getEstatisticasLivro();

    if (mapStats != null) {
      final stats = EstatisticasLivro.fromMap(mapStats);
      _livrosLendo = stats.livrosLendo;
      _livrosParaLer = stats.livrosParaLer;
      _livrosLidos = stats.livrosLidos;
      _paginasLendo = stats.paginasLendo;
      _paginasParaLer = stats.paginasParaLer;
      _paginasLidos = stats.paginasLidos;
      _livrosAdicionadosAnoAtual = stats.livrosAdicionadosAnoAtual;
      _mediaPaginas = stats.mediaPaginas;
      _menorLivroNome = stats.menorLivroNome;
      _maiorLivroNome = stats.maiorLivroNome;
      // DB CONTA O VALOR VAZIO, QUE ESTÁ CONFIGURADO PARA O LIVRO SEM AUTOR
      _quantidadeAutores = (stats.quantidadeAutores == 0) ? 0 : (stats.quantidadeAutores - 1);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas do Ano Atual'),       
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                EstatisticaLivrosPaginasCard(
                  livrosLendo: _livrosLendo ?? 0,
                  livrosParaLer: _livrosParaLer ?? 0,
                  livrosLidos: _livrosLidos ?? 0,
                  paginasLendo: _paginasLendo ?? 0,
                  paginasParaLer: _paginasParaLer ?? 0,
                  paginasLidos: _paginasLidos ?? 0,
                  accent: accent,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text('Geral', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: accent)),
                      ),
                      EstatisticaGeralCard(
                        titulo: 'Autores',
                        icon: Icons.person_outline_outlined,
                        valor: _quantidadeAutores,
                      ),
                      EstatisticaGeralCard(
                        titulo: 'Livros adicionados no ano atual',
                        icon: Icons.calendar_today_outlined,
                        valor: _livrosAdicionadosAnoAtual,
                      ),
                      EstatisticaGeralCard(
                        titulo: 'Média de páginas',
                        icon: Icons.analytics_outlined,
                        valor: _mediaPaginas,
                      ),
                      if (_menorLivroNome != null)
                        EstatisticaGeralCard(
                          titulo: 'Menor livro',
                          icon: Icons.arrow_downward_rounded,
                          valor: _menorLivroNome,
                        ),
                      if (_maiorLivroNome != null)
                        EstatisticaGeralCard(
                          titulo: 'Maior livro',
                          icon: Icons.arrow_upward_rounded,
                          valor: _maiorLivroNome,
                        ),
                    ])),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
    );
  }
}

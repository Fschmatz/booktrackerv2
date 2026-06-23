import 'package:booktrackerv2/class/livro_extension.dart';
import 'package:booktrackerv2/enum/situacao_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

import '../class/estatisticas_livro.dart';
import '../widgets/estatistica_card.dart';
import '../widgets/estatistica_autores_card.dart';
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
    final mapStats = await LivroService().getEstatisticasLivro();
    if (mapStats != null) {
      final stats = EstatisticasLivro.fromMap(mapStats);
      _livrosLendo = stats.livrosLendo;
      _livrosParaLer = stats.livrosParaLer;
      _livrosLidos = stats.livrosLidos;
      _paginasLendo = stats.paginasLendo;
      _paginasParaLer = stats.paginasParaLer;
      _paginasLidos = stats.paginasLidos;
      _quantidadeAutores = stats.quantidadeAutores;
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
        title: const Text('Estatísticas'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              children: [
                EstatisticaCard(
                  tituloCard: 'Livros',
                  valorLendo: _livrosLendo,
                  valorParaLer: _livrosParaLer,
                  valorLidos: _livrosLidos,
                  accent: accent,
                ),
                EstatisticaCard(
                  tituloCard: 'Páginas',
                  valorLendo: _paginasLendo,
                  valorParaLer: _paginasParaLer,
                  valorLidos: _paginasLidos,
                  accent: accent,
                ),
                EstatisticaAutoresCard(
                  tituloCard: 'Geral',
                  valor: _quantidadeAutores,
                  accent: accent,
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../class/historico_ano.dart';
import '../service/livro_service.dart';
import '../widgets/card_historico_ano.dart';
import 'lista_livro_imprimir.dart';

class Historico extends StatefulWidget {
  const Historico({Key? key}) : super(key: key);

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  final LivroService _livroService = LivroService();
  bool _loading = true;
  List<HistoricoAno> _listaHistorico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final historico = await _livroService.getHistoricoAnos();
    if (mounted) {
      setState(() {
        _listaHistorico = historico;
        _loading = false;
      });
    }
  }

  void _abrirDetalhesAno(HistoricoAno item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ListaLivroImprimir(
          onlyLidos: true,
          ano: item.ano,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Livros Lidos'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarHistorico,
              child: _listaHistorico.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 64,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum histórico encontrado',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Os livros finalizados com data aparecerão aqui agrupados por ano.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _listaHistorico.length,
                      itemBuilder: (context, index) {
                        final item = _listaHistorico[index];
                        return CardHistoricoAno(
                          key: ValueKey(item.ano),
                          historicoAno: item,
                          onTap: () => _abrirDetalhesAno(item),
                        );
                      },
                    ),
            ),
    );
  }
}

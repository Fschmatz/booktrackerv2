import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../class/livro.dart';
import '../enum/situacao_livro.dart';
import '../redux/selectors.dart';
import '../service/livro_service.dart';

class ListaLivroImprimir extends StatefulWidget {
  final bool onlyLidos;

  ListaLivroImprimir({Key? key, required this.onlyLidos}) : super(key: key);

  @override
  State<ListaLivroImprimir> createState() => _ListaLivroImprimirState();
}

class _ListaLivroImprimirState extends State<ListaLivroImprimir> {
  //final dbLivro = LivroDao.instance;
  List<Livro> _livrosLendo = [];
  List<Livro> _livrosParaLer = [];
  List<Livro> _livrosLidos = [];
  bool _loading = true;
  String _listaFormatada = '';

  @override
  void initState() {
    super.initState();

    _loadLivros();
  }

  void _loadLivros() async {
    await LivroService().loadAllLivrosParaEstatisticas();

    _livrosLidos = await selectListLivroByPaginaAtual(SituacaoLivro.LIDO);

    if (!widget.onlyLidos) {
      _livrosLendo = await selectListLivroByPaginaAtual(SituacaoLivro.LENDO);
      _livrosParaLer = await selectListLivroByPaginaAtual(SituacaoLivro.PARA_LER);

      _listaFormatada += "# Lendo\n";
      for (int i = 0; i < _livrosLendo.length; i++) {
        _listaFormatada += "• " + _livrosLendo[i].nome.toString() + "\n";
      }

      _listaFormatada += "\n";
      _listaFormatada += "# Para Ler\n";
      for (int i = 0; i < _livrosParaLer.length; i++) {
        _listaFormatada += "• " + _livrosParaLer[i].nome.toString() + "\n";
      }

      _listaFormatada += "\n";
    }

    _listaFormatada += "# Lidos\n";
    for (int i = 0; i < _livrosLidos.length; i++) {
      _listaFormatada += "• " + _livrosLidos[i].nome.toString() + "\n";
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista'),
        actions: [
          TextButton(
            child: const Text(
              "Copiar",
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _listaFormatada));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        children: [
          _loading
              ? const SizedBox.shrink()
              : SelectableText(
                  _listaFormatada,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/livro_dao.dart';

class ListaLivroImprimir extends StatefulWidget {
  final bool onlyLidos;

  ListaLivroImprimir({Key? key, required this.onlyLidos}) : super(key: key);

  @override
  State<ListaLivroImprimir> createState() => _ListaLivroImprimirState();
}

class _ListaLivroImprimirState extends State<ListaLivroImprimir> {
  final dbLivro = LivroDao.instance;
  List<Map<String, dynamic>> listaLivrosLendo = [];
  List<Map<String, dynamic>> listaLivrosParaLer = [];
  List<Map<String, dynamic>> listaLivrosLidos = [];
  bool loading = true;
  String listaFormatada = '';

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  void _loadLivros() async {
    listaLivrosLidos = await dbLivro.queryAllLivrosByEstado(2);

    if (!widget.onlyLidos) {
      listaLivrosLendo = await dbLivro.queryAllLivrosByEstado(0);
      listaLivrosParaLer = await dbLivro.queryAllLivrosByEstado(1);

      listaFormatada += "# Lendo\n";
      for (int i = 0; i < listaLivrosLendo.length; i++) {
        listaFormatada += "• " + listaLivrosLendo[i]['nome'].toString() + "\n";
      }

      listaFormatada += "\n";
      listaFormatada += "# Para Ler\n";
      for (int i = 0; i < listaLivrosParaLer.length; i++) {
        listaFormatada += "• " + listaLivrosParaLer[i]['nome'].toString() + "\n";
      }

      listaFormatada += "\n";
    }

    listaFormatada += "# Lidos\n";
    for (int i = 0; i < listaLivrosLidos.length; i++) {
      listaFormatada += "• " + listaLivrosLidos[i]['nome'].toString() + "\n";
    }

    setState(() {
      loading = false;
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
              Clipboard.setData(ClipboardData(text: listaFormatada));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        children: [
          loading
              ? const SizedBox.shrink()
              : SelectableText(
                  listaFormatada,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}

import 'package:booktrackerv2/class/livro_extension.dart';
import 'package:booktrackerv2/enum/situacao_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

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

    _livrosLendo = await selectListLivroByPaginaAtual(SituacaoLivro.LENDO).quantidade;
    _livrosParaLer = await selectListLivroByPaginaAtual(SituacaoLivro.PARA_LER).quantidade;
    _livrosLidos = await selectListLivroByPaginaAtual(SituacaoLivro.LIDO).quantidade;
    _paginasLendo = await selectListLivroByPaginaAtual(SituacaoLivro.LENDO).totalPaginas;
    _paginasParaLer = await selectListLivroByPaginaAtual(SituacaoLivro.PARA_LER).totalPaginas;
    _paginasLidos = await selectListLivroByPaginaAtual(SituacaoLivro.LIDO).totalPaginas;

    var respAutores = await LivroService().findContagemAutoresDistinct();
    _quantidadeAutores = respAutores ?? 0;

    setState(() {
      _loading = false;
    });
  }

  Widget cardEstatisticas(String tituloCard, int? valorLendo, int? valorParaLer, int? valorLidos, Color accent) {
    TextStyle styleTrailing = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    int soma = (valorLidos! + valorParaLer! + valorLendo!);

    return Column(
      children: [
        ListTile(
          title: Text(tituloCard, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: accent)),
        ),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text('Lendo'),
          trailing: Text(valorLendo.toString(), style: styleTrailing),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outline_outlined),
          title: const Text('Para Ler'),
          trailing: Text(valorParaLer.toString(), style: styleTrailing),
        ),
        ListTile(
          leading: const Icon(Icons.task_outlined),
          title: const Text('Lidos'),
          trailing: Text(valorLidos.toString(), style: styleTrailing),
        ),
        ListTile(
          leading: const Icon(Icons.format_list_bulleted_outlined),
          title: const Text('Total'),
          trailing: Text(
            soma.toString(),
            style: styleTrailing,
          ),
        ),
      ],
    );
  }

  Widget cardAutores(String tituloCard, int? valor, Color accent) {
    TextStyle styleTrailing = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

    //DB CONTA O VALOR VAZIO, QUE ESTÁ CONFIGURADO PARA O LIVRO SEM AUTOR
    int valorCalculado = valor == 0 ? 0 : (valor! - 1);

    return Column(
      children: [
        ListTile(
          title: Text(tituloCard, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: accent)),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline_outlined),
          title: const Text('Autores'),
          trailing: Text(valorCalculado.toString(), style: styleTrailing),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent = Theme.of(context).colorScheme.primary;

    return _loading
        ? const Center(child: SizedBox.shrink())
        : ListView(
            children: [
              cardEstatisticas('Livros', _livrosLendo, _livrosParaLer, _livrosLidos, accent),
              cardEstatisticas('Páginas', _paginasLendo, _paginasParaLer, _paginasLidos, accent),
              cardAutores('Geral', _quantidadeAutores, accent),
              const SizedBox(
                height: 50,
              ),
            ],
          );
  }
}

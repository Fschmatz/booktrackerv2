import 'livro.dart';

extension LivroListExtensions on List<Livro> {
  int get quantidade => length;

  int get totalPaginas {
    return fold(0, (sum, livro) => sum + (livro.numPaginas ?? 0));
  }

  int get autoresDistintos {
    final autores = where((livro) => livro.autor != null && livro.autor!.isNotEmpty).map((livro) => livro.autor).toSet();
    return autores.length;
  }
}

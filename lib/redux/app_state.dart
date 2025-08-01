import '../class/livro.dart';

class AppState {
  List<Livro> listLendo;
  List<Livro> listParaLer;
  List<Livro> listLido;
  int paginaAtual;

  AppState({required this.listLendo, required this.listParaLer, required this.listLido, required this.paginaAtual});

  static AppState initialState() => AppState(listLendo: [], listParaLer: [], listLido: [], paginaAtual: 0);

  AppState copyWith({List<Livro>? listLendo, List<Livro>? listParaLer, List<Livro>? listLido, int? paginaAtual}) {
    return AppState(
        listLendo: listLendo ?? this.listLendo,
        listParaLer: listParaLer ?? this.listParaLer,
        listLido: listLido ?? this.listLido,
        paginaAtual: paginaAtual ?? this.paginaAtual);
  }
}

import '../class/livro.dart';

class AppState {
  List<Livro> listLendo;
  List<Livro> listParaLer;
  List<Livro> listLido;

  AppState({required this.listLendo, required this.listParaLer, required this.listLido});

  static AppState initialState() => AppState(listLendo: [], listParaLer: [], listLido: []);

  AppState copyWith({List<Livro>? listLendo, List<Livro>? listParaLer, List<Livro>? listLido, int? paginaAtual}) {
    return AppState(listLendo: listLendo ?? this.listLendo, listParaLer: listParaLer ?? this.listParaLer, listLido: listLido ?? this.listLido);
  }
}

import '../class/app_parameter.dart';
import '../class/livro.dart';

class AppState {
  List<Livro> listLendo;
  List<Livro> listParaLer;
  List<Livro> listLido;
  List<AppParameter> appParameters;

  AppState(
      {required this.listLendo,
      required this.listParaLer,
      required this.listLido,
      required this.appParameters});

  static AppState initialState() =>
      AppState(listLendo: [], listParaLer: [], listLido: [], appParameters: []);

  AppState copyWith(
      {List<Livro>? listLendo,
      List<Livro>? listParaLer,
      List<Livro>? listLido,
      List<AppParameter>? appParameters,
      int? paginaAtual}) {
    return AppState(
        listLendo: listLendo ?? this.listLendo,
        listParaLer: listParaLer ?? this.listParaLer,
        listLido: listLido ?? this.listLido,
        appParameters: appParameters ?? this.appParameters);
  }
}

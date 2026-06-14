import '../class/app_parameter.dart';
import '../class/livro.dart';
import '../enum/situacao_livro.dart';

class AppState {
  final List<Livro> listLendo;
  final List<Livro> listParaLer;
  final List<Livro> listLido;
  final List<AppParameter> appParameters;
  final SituacaoLivro currentTab;

  AppState(
      {required this.listLendo,
      required this.listParaLer,
      required this.listLido,
      required this.appParameters,
      required this.currentTab});

  static AppState initialState() => AppState(
      listLendo: [],
      listParaLer: [],
      listLido: [],
      appParameters: [],
      currentTab: SituacaoLivro.LENDO);

  AppState copyWith(
      {List<Livro>? listLendo,
      List<Livro>? listParaLer,
      List<Livro>? listLido,
      List<AppParameter>? appParameters,
      SituacaoLivro? currentTab}) {
    return AppState(
        listLendo: listLendo ?? this.listLendo,
        listParaLer: listParaLer ?? this.listParaLer,
        listLido: listLido ?? this.listLido,
        appParameters: appParameters ?? this.appParameters,
        currentTab: currentTab ?? this.currentTab);
  }
}

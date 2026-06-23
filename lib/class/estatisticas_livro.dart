class EstatisticasLivro {
  final int livrosLendo;
  final int livrosParaLer;
  final int livrosLidos;
  final int paginasLendo;
  final int paginasParaLer;
  final int paginasLidos;
  final int quantidadeAutores;

  EstatisticasLivro({
    required this.livrosLendo,
    required this.livrosParaLer,
    required this.livrosLidos,
    required this.paginasLendo,
    required this.paginasParaLer,
    required this.paginasLidos,
    required this.quantidadeAutores,
  });

  factory EstatisticasLivro.fromMap(Map<String, dynamic> map) {
    return EstatisticasLivro(
      livrosLendo: map['livrosLendo'] ?? 0,
      livrosParaLer: map['livrosParaLer'] ?? 0,
      livrosLidos: map['livrosLidos'] ?? 0,
      paginasLendo: map['paginasLendo'] ?? 0,
      paginasParaLer: map['paginasParaLer'] ?? 0,
      paginasLidos: map['paginasLidos'] ?? 0,
      quantidadeAutores: map['quantidadeAutores'] ?? 0,
    );
  }
}

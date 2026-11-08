class EstatisticasLivro {
  final int livrosLendo;
  final int livrosParaLer;
  final int livrosLidos;
  final int paginasLendo;
  final int paginasParaLer;
  final int paginasLidos;
  final int quantidadeAutores;
  final int livrosAdicionadosAnoAtual;
  final int mediaPaginas;
  final String? menorLivroNome;
  final int? menorLivroPaginas;
  final String? maiorLivroNome;
  final int? maiorLivroPaginas;

  EstatisticasLivro({
    required this.livrosLendo,
    required this.livrosParaLer,
    required this.livrosLidos,
    required this.paginasLendo,
    required this.paginasParaLer,
    required this.paginasLidos,
    required this.quantidadeAutores,
    required this.livrosAdicionadosAnoAtual,
    this.mediaPaginas = 0,
    this.menorLivroNome,
    this.menorLivroPaginas,
    this.maiorLivroNome,
    this.maiorLivroPaginas,
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
      livrosAdicionadosAnoAtual: map['livrosAdicionadosAnoAtual'] ?? 0,
      mediaPaginas: (map['mediaPaginas'] is num) ? (map['mediaPaginas'] as num).round() : 0,
      menorLivroNome: map['menorLivroNome'] as String?,
      menorLivroPaginas: map['menorLivroPaginas'] as int?,
      maiorLivroNome: map['maiorLivroNome'] as String?,
      maiorLivroPaginas: map['maiorLivroPaginas'] as int?,
    );
  }
}

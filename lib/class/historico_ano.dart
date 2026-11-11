class HistoricoAno {
  final String ano;
  final int quantidadeLidos;
  final int totalPaginas;

  HistoricoAno({
    required this.ano,
    required this.quantidadeLidos,
    required this.totalPaginas,
  });

  factory HistoricoAno.fromMap(Map<String, dynamic> map) {
    return HistoricoAno(
      ano: map['ano'].toString(),
      quantidadeLidos: (map['quantidadeLivros'] as num?)?.toInt() ?? 0,
      totalPaginas: (map['totalPaginas'] as num?)?.toInt() ?? 0,
    );
  }
}


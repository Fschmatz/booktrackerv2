enum SituacaoLivro {
  LENDO(
    0,
    "Lendo",
  ),
  PARA_LER(
    1,
    "Para Ler",
  ),
  LIDO(
    2,
    "Lido",
  );

  const SituacaoLivro(this.id, this.nome);

  final int id;
  final String nome;

  static SituacaoLivro fromId(int id) {
    return SituacaoLivro.values.firstWhere((e) => e.id == id);
  }
}

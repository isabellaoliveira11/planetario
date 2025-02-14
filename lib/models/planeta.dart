// Modelo da classe Planeta
class Planeta {
  final int? id; // ID do planeta (pode ser nulo se for um novo planeta)
  final String nome; // Nome do planeta (obrigatório)
  final String? apelido; // Apelido do planeta (opcional)
  final double distanciaSol; // Distância do planeta ao sol (obrigatório)
  final double tamanho; // Tamanho do planeta (obrigatório)

  const Planeta({
    this.id,
    required this.nome,
    this.apelido,
    required this.distanciaSol,
    required this.tamanho,
  });

  // Converte um objeto Planeta para um mapa (para salvar no banco de dados, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'distancia_sol': distanciaSol, // Nome da chave consistente com o padrão snake_case
      'tamanho': tamanho,
    };
  }

  // Cria um objeto Planeta a partir de um mapa (recuperado do banco de dados, por exemplo)
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String?,
      distanciaSol: map['distancia_sol'] is double // Verifica o tipo antes de fazer o cast
          ? map['distancia_sol'] as double
          : map['distancia_sol'] is int // Trata o caso de ser um inteiro (comum em bancos de dados)
              ? (map['distancia_sol'] as int).toDouble() // Converte para double
              : 0.0, // Valor padrão se não for double nem int
      tamanho: map['tamanho'] is double // Verifica o tipo antes de fazer o cast
          ? map['tamanho'] as double
          : map['tamanho'] is int // Trata o caso de ser um inteiro
              ? (map['tamanho'] as int).toDouble() // Converte para double
              : 0.0, // Valor padrão se não for double nem int
    );
  }

  // Cria uma cópia do objeto Planeta com alguns campos alterados (útil para atualizar dados)
  Planeta copyWith({
    int? id,
    String? nome,
    String? apelido,
    double? distanciaSol,
    double? tamanho,
  }) {
    return Planeta(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      distanciaSol: distanciaSol ?? this.distanciaSol,
      tamanho: tamanho ?? this.tamanho,
    );
  }
}
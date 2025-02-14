import 'package:planetario/models/planeta.dart';
import 'package:planetario/controllers/database_helper.dart';

// Controlador para as operações relacionadas aos planetas no banco de dados
class PlanetaController {
  // Lista todos os planetas do banco de dados
  Future<List<Planeta>> listarPlanetas() async {
    try {
      final db = await DatabaseHelper().database; // Obtém uma instância do banco de dados
      final maps = await db.query('planetas'); // Consulta a tabela 'planetas'

      // Converte os mapas (resultados da consulta) em objetos Planeta e retorna uma lista
      return maps.map((map) => Planeta.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao listar planetas: $e'); // Imprime o erro no console para depuração
      throw Exception('Erro ao listar planetas'); // Lança uma exceção para ser tratada na camada superior
    }
  }

  // Cadastra um novo planeta no banco de dados
  Future<void> cadastrarPlaneta(Planeta planeta) async {
    try {
      final db = await DatabaseHelper().database; // Obtém uma instância do banco de dados
      await db.insert('planetas', planeta.toMap()); // Insere o planeta na tabela 'planetas'
    } catch (e) {
      print('Erro ao cadastrar planeta: $e'); // Imprime o erro no console
      throw Exception('Erro ao cadastrar planeta'); // Lança uma exceção
    }
  }

  // Atualiza um planeta existente no banco de dados
  Future<void> atualizarPlaneta(Planeta planeta) async {
    try {
      final db = await DatabaseHelper().database; // Obtém uma instância do banco de dados
      await db.update(
        'planetas',
        planeta.toMap(), // Mapa com os dados do planeta a serem atualizados
        where: 'id = ?', // Cláusula WHERE para identificar o planeta a ser atualizado
        whereArgs: [planeta.id], // Argumentos para a cláusula WHERE (evita injeção de SQL)
      );
    } catch (e) {
      print('Erro ao atualizar planeta: $e'); // Imprime o erro no console
      throw Exception('Erro ao atualizar planeta'); // Lança uma exceção
    }
  }

  // Exclui um planeta do banco de dados
  Future<void> excluirPlaneta(int id) async {
    try {
      final db = await DatabaseHelper().database; // Obtém uma instância do banco de dados
      await db.delete(
        'planetas',
        where: 'id = ?', // Cláusula WHERE para identificar o planeta a ser excluído
        whereArgs: [id], // Argumentos para a cláusula WHERE
      );
    } catch (e) {
      print('Erro ao excluir planeta: $e'); // Imprime o erro no console
      throw Exception('Erro ao excluir planeta'); // Lança uma exceção
    }
  }
}
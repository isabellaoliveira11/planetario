import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/planeta.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Obtém o banco de dados. Se já existir, retorna a instância existente.
  // Se não existir, inicializa e retorna uma nova instância.
  Future<Database> get database async => _database ??= await _initDatabase();

  // Inicializa o banco de dados.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'planeta_database.db');

 
    return openDatabase(
      path,
      version: 2, // Versão do banco de dados (incrementar para aplicar migrations)
      onCreate: (db, version) async {
        // Cria a tabela 'planetas' na primeira vez que o banco de dados é criado.
        await db.execute(
          'CREATE TABLE planetas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, distancia_sol REAL, tamanho REAL, apelido TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Executa migrations quando a versão do banco de dados é incrementada.
        if (oldVersion < 2) {
          // Adiciona a coluna 'apelido' se a versão for menor que 2.
          await db.execute('ALTER TABLE planetas ADD COLUMN apelido TEXT');
        }
        // Adicione outras migrations aqui, se necessário.
      },
    );
  }


  // Insere um planeta no banco de dados.
  // `conflictAlgorithm: ConflictAlgorithm.ignore` ignora inserções duplicadas (mesmo ID).
  Future<void> inserirPlaneta(Planeta planeta) async {
    final db = await database;
    try {
      await db.insert(
        'planetas',
        planeta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // Lida com IDs duplicados
      );
    } catch (e) {
      print('Erro ao inserir planeta: $e');
    }
  }

  // Busca todos os planetas no banco de dados.
  Future<List<Planeta>> buscarTodosPlanetas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('planetas');

    // Converte os mapas em objetos Planeta.
    return maps.map((map) => Planeta.fromMap(map)).toList();
  }

  // Atualiza um planeta no banco de dados.
  Future<void> atualizarPlaneta(Planeta planeta) async {
    final db = await database;
    await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id], // Previne injeção de SQL
    );
  }

  // Exclui um planeta do banco de dados.
  Future<void> excluirPlaneta(int id) async {
    final db = await database;
    await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id], // Previne injeção de SQL
    );
  }
}